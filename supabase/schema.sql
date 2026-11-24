-- 물풍선 퐁퐁: Supabase SQL Editor에 통째로 붙여넣고 [Run] 하세요.
--
-- 이미 다른 앱에서 쓰고 있는 Supabase 프로젝트에 넣어도 되도록 만들었어요.
--  * 테이블·함수 이름이 모두 pongpong_ 으로 시작해서 기존 profiles 테이블 등과 겹치지 않아요.
--  * auth.users에 트리거를 달지 않아요. 프로필은 게임에 처음 로그인할 때 게임이 직접 만들어요.
--  * 기존 테이블이나 설정은 건드리지 않아요.

-- 1) 플레이어 프로필 (닉네임·캐릭터·전적)
create table if not exists public.pongpong_profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  nickname    text not null default '친구' check (char_length(nickname) between 1 and 8),
  ch          smallint not null default 0 check (ch between 0 and 3),
  wins        integer not null default 0 check (wins >= 0),
  games       integer not null default 0 check (games >= 0),
  updated_at  timestamptz not null default now()
);

alter table public.pongpong_profiles enable row level security;

-- 로그인한 사람은 순위표를 위해 모든 게임 프로필을 볼 수 있어요.
drop policy if exists "pongpong: signed-in users can read" on public.pongpong_profiles;
create policy "pongpong: signed-in users can read"
  on public.pongpong_profiles for select to authenticated using (true);

-- 자기 프로필만 만들고 고칠 수 있어요.
drop policy if exists "pongpong: insert own" on public.pongpong_profiles;
create policy "pongpong: insert own"
  on public.pongpong_profiles for insert to authenticated with check ((select auth.uid()) = id);

drop policy if exists "pongpong: update own" on public.pongpong_profiles;
create policy "pongpong: update own"
  on public.pongpong_profiles for update to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

-- 승수·판수는 직접 못 고치고, 아래 pongpong_record_game 함수로만 올라가요.
revoke all on public.pongpong_profiles from anon, authenticated;
grant select on public.pongpong_profiles to authenticated;
grant insert (id, nickname, ch) on public.pongpong_profiles to authenticated;
grant update (nickname, ch, updated_at) on public.pongpong_profiles to authenticated;

-- 2) 한 판 끝날 때 전적 기록
create or replace function public.pongpong_record_game(won boolean)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.pongpong_profiles
     set games = games + 1,
         wins = wins + case when won then 1 else 0 end,
         updated_at = now()
   where id = auth.uid();
$$;

revoke execute on function public.pongpong_record_game(boolean) from public, anon;
grant execute on function public.pongpong_record_game(boolean) to authenticated;

-- 게임을 지우고 싶을 때는 아래 두 줄을 실행하면 깨끗하게 사라져요.
-- drop function if exists public.pongpong_record_game(boolean);
-- drop table if exists public.pongpong_profiles;
