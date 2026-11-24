-- 물풍선 퐁퐁: Supabase SQL Editor에 통째로 붙여넣고 [Run] 하세요.

-- 1) 플레이어 프로필 (닉네임·캐릭터·전적)
create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  nickname    text not null default '친구' check (char_length(nickname) between 1 and 8),
  ch          smallint not null default 0 check (ch between 0 and 3),
  wins        integer not null default 0 check (wins >= 0),
  games       integer not null default 0 check (games >= 0),
  updated_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- 로그인한 사람은 순위표를 위해 모든 프로필을 볼 수 있어요.
drop policy if exists "profiles: signed-in users can read" on public.profiles;
create policy "profiles: signed-in users can read"
  on public.profiles for select to authenticated using (true);

-- 자기 프로필만 만들고 고칠 수 있어요.
drop policy if exists "profiles: insert own" on public.profiles;
create policy "profiles: insert own"
  on public.profiles for insert to authenticated with check ((select auth.uid()) = id);

drop policy if exists "profiles: update own" on public.profiles;
create policy "profiles: update own"
  on public.profiles for update to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

-- 승수·판수는 직접 못 고치고, 아래 record_game 함수로만 올라가요.
revoke insert, update on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;
grant insert (id, nickname, ch) on public.profiles to authenticated;
grant update (nickname, ch, updated_at) on public.profiles to authenticated;

-- 2) 가입하면 프로필 자동 생성 (카카오 닉네임 또는 이메일 앞부분 사용)
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, nickname)
  values (
    new.id,
    left(coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
      nullif(trim(new.raw_user_meta_data ->> 'nickname'), ''),
      nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      '친구'
    ), 8)
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3) 한 판 끝날 때 전적 기록
create or replace function public.record_game(won boolean)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.profiles
     set games = games + 1,
         wins = wins + case when won then 1 else 0 end,
         updated_at = now()
   where id = auth.uid();
$$;

revoke execute on function public.record_game(boolean) from public, anon;
grant execute on function public.record_game(boolean) to authenticated;
