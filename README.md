# 물풍선 퐁퐁 — 설치·배포 안내

카카오 로그인과 이메일 로그인, 친구와 온라인 대전, 전적·순위 저장이 되는 버전이에요.
서버 코드는 따로 없어요. **Supabase**(로그인·데이터베이스·실시간 연결)와 **GitHub Pages**(무료 사이트 호스팅)만 있으면 돼요.

```
pongpong/
├─ index.html              게임 본체
├─ config.js               ← Supabase 주소와 키를 여기에 넣어요
├─ manifest.webmanifest    휴대폰 "홈 화면에 추가"용
├─ icon.svg, icon-*.png    앱 아이콘
└─ supabase/schema.sql     데이터베이스 설정 (한 번만 실행)
```

준비물: Supabase 계정, GitHub 계정, 카카오 계정. 모두 무료예요.

아래 안내에서 `내아이디`는 GitHub 아이디, `pongpong`은 저장소 이름이에요. 사이트 주소는 `https://내아이디.github.io/pongpong/`가 돼요.

---

## 1. Supabase 준비하기

Supabase 무료 플랜은 한 계정에 활성 프로젝트를 **2개까지**만 만들 수 있어요. 두 가지 방법 중 하나를 고르세요.

- **A. 이미 쓰는 프로젝트에 함께 넣기 (추천, 무료)**
  - 새 프로젝트를 만들지 않고, 지금 있는 프로젝트를 그대로 써요.
  - 게임이 쓰는 테이블과 함수는 이름이 모두 `pongpong_`으로 시작해요. 그래서 기존 `profiles` 같은 테이블과 겹치지 않고, 기존 데이터나 설정도 건드리지 않아요.
- **B. 안 쓰는 프로젝트 정리하기**
  - 쓰지 않는 프로젝트를 **Pause**하거나 삭제하면 자리가 생겨요. 일시 중지된 프로젝트는 2개에 포함되지 않아요.
  - 그다음 **New project**로 새로 만들어요. Region은 **Northeast Asia (Seoul)**이 한국에서 빨라요.

어느 쪽이든 그다음은 같아요.

1. 쓸 프로젝트를 열어요.
2. 왼쪽 메뉴 **SQL Editor**를 열고 `supabase/schema.sql` 내용을 통째로 붙여넣은 뒤 **Run**을 눌러요.
   - 게임 프로필 테이블 `pongpong_profiles`, 보안 규칙, 전적 기록 함수 `pongpong_record_game`이 만들어져요.
   - 게임을 지우고 싶으면 파일 맨 아래 주석에 있는 두 줄을 실행하면 깨끗하게 사라져요.
3. 프로젝트 화면 위쪽 **Connect** 버튼(또는 **Project Settings → API Keys**)에서 두 값을 복사해요.
   - **Project URL**: `https://abcdefgh.supabase.co` 같은 주소
   - **Publishable key**(예전 이름: anon public key)
4. `config.js`를 메모장 같은 편집기로 열어 두 값을 붙여넣어요.

```js
window.PP_CONFIG = {
  SUPABASE_URL: 'https://abcdefgh.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_xxxxxxxx'
};
```

> ⚠️ `service_role` 키나 `secret` 키는 절대 넣지 마세요. 웹페이지에 들어가는 건 publishable(anon) 키뿐이에요.

## 2. 사이트 올리기 (GitHub Pages)

git 명령어 없이 웹사이트에서 끌어다 놓기만 하면 돼요.

### 2-1. 저장소 만들기

1. https://github.com 에 가입하고 로그인해요.
2. 오른쪽 위 **+** → **New repository**를 눌러요.
3. 저장소를 만들어요.
   - **Repository name**: `pongpong`
   - 공개 범위: **Public**
   - 무료 계정은 Public 저장소에서만 GitHub Pages를 쓸 수 있어요.
4. **Create repository**를 눌러요.

### 2-2. 파일 올리기

1. 새 저장소 화면에서 **uploading an existing file** 링크를 눌러요.
2. 압축을 푼 `pongpong` 폴더를 열고, **폴더 안의 파일과 `supabase` 폴더 전부**를 선택해서 끌어다 놓아요.
   - `pongpong` 폴더 자체를 올리면 주소가 한 단계 깊어지니, 꼭 안의 내용물을 올려 주세요.
   - `index.html`이 저장소 맨 위에 있어야 해요.
3. 아래 **Commit changes**를 눌러요.

### 2-3. 사이트 켜기

1. 저장소의 **Settings → Pages**로 가요.
2. **Build and deployment**에서 아래처럼 고르고 **Save**를 눌러요.
   - **Source**: Deploy from a branch
   - **Branch**: `main` / `(root)`
3. 1~2분 뒤 같은 화면 위쪽에 사이트 주소가 나와요: `https://내아이디.github.io/pongpong/`

### 2-4. 수정할 때

- **config.js처럼 파일 하나만 고칠 때**: 저장소에서 파일을 누르고 연필 아이콘(✏️ Edit)으로 바로 고친 뒤 **Commit changes**를 눌러요.
- **새 버전 파일로 바꿀 때**: **Add file → Upload files**로 같은 이름의 파일을 다시 올리면 덮어써져요.
- 어느 쪽이든 1~2분 뒤 사이트에 자동으로 반영돼요. 반영이 안 보이면 새로고침해 보세요.

> `config.js`의 publishable(anon) 키는 원래 웹페이지에 공개되는 값이라 Public 저장소에 올려도 괜찮아요.
> 대신 `service_role`·`secret` 키는 절대 올리면 안 돼요.

> 이 페이지는 반드시 `https://` 주소로 열어야 해요. 파일을 더블클릭해서 열면 컴퓨터와 하는 연습 게임만 돼요.

## 3. Supabase에 사이트 주소 알려주기

Supabase 대시보드 **Authentication → URL Configuration**에서 설정해요.

- **Redirect URLs**에 `https://내아이디.github.io/pongpong/**`를 **추가**해요. 주소 끝의 `/pongpong/`까지 꼭 넣어 주세요.
- **Site URL**은 상황에 따라 달라요.
  - 게임 전용 프로젝트라면 `https://내아이디.github.io/pongpong/`로 바꿔요.
  - 다른 앱과 함께 쓰는 프로젝트(1번의 A)라면 **Site URL은 그대로 두세요.** 바꾸면 기존 앱의 로그인 이동이 망가질 수 있어요. 게임은 Redirect URLs에 추가한 주소만으로 동작해요.

이 설정이 없으면 카카오 로그인이나 인증 메일 링크를 누른 뒤 엉뚱한 곳으로 이동해요.

## 4. 이메일 로그인 설정

이메일 로그인은 Supabase에서 기본으로 켜져 있어요. (**Authentication → Sign In / Providers → Email**)

다만 Supabase의 기본 메일 발송은 **프로젝트 팀원 주소로만** 보내지고, **시간당 2통** 정도로 제한돼 있어요. 그래서 친구들이 가입할 때 인증 메일이 오지 않아요. 두 가지 중 하나를 고르세요.

- **간단하게 (친구끼리 쓸 때 추천)**: Email 설정에서 **Confirm email**을 꺼요. 가입하는 즉시 로그인돼요. 대신 "비밀번호를 잊었어요" 메일은 여전히 팀원에게만 가요.
  - ⚠️ 다른 앱과 함께 쓰는 프로젝트라면 이 설정은 그 앱에도 똑같이 적용돼요. 기존 앱이 이메일 인증을 꼭 써야 한다면 끄지 말고 아래 SMTP 방법을 쓰세요.
- **제대로 하기**: **Authentication → Emails → SMTP Settings**에서 Resend나 Brevo 같은 메일 서비스(무료 플랜 있음)를 연결해요. 그러면 인증 메일과 비밀번호 재설정 메일이 누구에게나 가요.

## 5. 카카오 로그인 설정

> 함께 쓰는 프로젝트에 **이미 카카오 로그인이 켜져 있다면** 이 단계는 건너뛰어도 돼요.
> Supabase 프로젝트 하나에는 카카오 앱 하나만 연결되니, 게임도 그 카카오 앱으로 로그인돼요. 3번의 Redirect URLs만 추가하면 끝이에요.

### 5-1. 카카오 디벨로퍼스

https://developers.kakao.com 에 카카오 계정으로 로그인해요.

1. **앱 → 앱 만들기**: 앱 이름(예: 물풍선 퐁퐁), 회사명(개인이면 본인 이름), 카테고리(게임), 대표 도메인(`https://내아이디.github.io`)을 넣고 저장해요.
2. **앱 설정 → 앱 → 플랫폼 키**에서 **REST API 키**를 복사해요. 이게 **Client ID**예요.
3. 같은 곳에서 REST API 키를 눌러 편집 화면으로 들어가요.
   - **카카오 로그인 Client Secret** 코드를 만들고 **활성화**해요. 이게 **Client Secret**이에요.
   - **카카오 로그인 Redirect URI**에 `https://<프로젝트-ref>.supabase.co/auth/v1/callback`을 넣고 저장해요.
   - 이 주소는 Supabase의 Kakao 설정 화면(5-2)에 **Callback URL**로 나와 있어요. 그대로 복사해 오면 돼요.
4. **제품 설정 → 카카오 로그인 → 일반**에서 사용 설정 **상태를 ON**으로 켜요.
5. **제품 설정 → 카카오 로그인 → 동의항목**에서 **닉네임**(profile_nickname)과 **프로필 사진**(profile_image)을 켜요.
   - **카카오계정(이메일)**(account_email)은 **비즈 앱**으로 전환해야 설정할 수 있어요.
   - **앱 설정 → 앱 → 일반**의 비즈니스 정보에서 전환해요. 사업자가 없어도 개인 개발자 비즈 앱으로 전환할 수 있어요.

### 5-2. Supabase

1. **Authentication → Sign In / Providers → Kakao**를 열어요.
2. **Kakao Enabled**를 켜고, Client ID(REST API 키)와 Client Secret을 넣어요.
3. 이메일 동의항목을 받지 않았다면 **Allow users without an email**도 켜요.
4. **Save**를 눌러요.

> 카카오 로그인 중에 **KOE205**(설정하지 않은 동의 항목: account_email) 오류가 나면 이메일 동의항목 문제예요.
> 비즈 앱으로 전환해서 이메일 동의항목을 켜거나, 3번의 **Allow users without an email**을 켜고 다시 해 보세요.

## 6. 친구와 하기

1. 사이트 주소를 친구에게 보내요.
2. 각자 카카오나 이메일로 로그인해요.
3. 한 명이 **방 만들기** → 4자리 방 코드를 알려주고, 친구는 **참가**에 코드를 넣어요.
4. 방장이 모드·맵·컴퓨터 실력을 고르고 **게임 시작**!

한 판이 끝날 때마다 각자의 승수와 판수가 저장되고, 메뉴의 **승리 순위**에 반영돼요.
닉네임과 캐릭터도 계정에 저장되니 휴대폰과 PC를 바꿔도 그대로예요.

### 휴대폰에 앱처럼 설치하기

- **아이폰(사파리)**: 공유 버튼 → **홈 화면에 추가**
- **안드로이드(크롬)**: 메뉴 ⋮ → **앱 설치** 또는 **홈 화면에 추가**

홈 화면 아이콘으로 열면 주소창 없이 전체 화면으로 열려요.

## 7. 무료 플랜으로 얼마나 놀 수 있나요?

Supabase 무료 플랜 실시간 연결 한도는 아래와 같아요.

| 항목 | 한도 |
|---|---|
| 동시 접속 | 200명 |
| 메시지 | 초당 100개, 월 200만 개 |

게임은 방장 화면이 초당 10번 게임 상태를 보내요. 4명이 3분 한 판을 하면 대략 7천~8천 메시지가 들어요.

- 한 달에 약 250판 정도는 무료로 충분해요.
- **동시에 여러 판**을 돌리면 초당 한도에 걸릴 수 있어요. 동시에 2~3판 정도가 무료 플랜의 적정선이에요.

다른 앱과 프로젝트를 함께 쓰면 이 한도도 함께 나눠 써요.

무료 프로젝트는 오래 쓰지 않으면 일시 중지될 수 있어요. 그럴 때는 Supabase 대시보드에서 다시 켜면 돼요.

## 8. 문제 해결

| 증상 | 확인할 것 |
|---|---|
| 사이트 주소가 404 | 2-3번 Pages 설정, `index.html`이 저장소 맨 위에 있는지, 1~2분 기다렸는지 |
| 첫 화면 문구가 "config.js에 Supabase 주소와 키를 넣어 주세요" | `config.js` 값이 그대로 예시로 남아 있지 않은지 |
| 카카오 로그인 후 다른 주소로 이동 | 3번의 Site URL / Redirect URLs (끝의 `/pongpong/` 포함) |
| 카카오 KOE006 오류 | 카카오 Redirect URI가 Supabase Callback URL과 정확히 같은지 |
| 카카오 KOE205 오류 | 5번의 이메일 동의항목 안내 |
| 가입했는데 메일이 안 와요 | 4번 (Confirm email 끄기 또는 SMTP 연결) |
| "이미 가입된 이메일" | 로그인 버튼으로 들어가기 |
| 방 코드로 참가가 안 돼요 | 두 사람 모두 로그인했는지, 코드 4자리가 맞는지 |
| 순위표가 비어 있어요 | `schema.sql`을 실행했는지 (Table Editor에 `pongpong_profiles`가 보이는지) |

## 참고

- **같은 프로젝트를 쓰는 다른 앱 계정**: 다른 앱과 프로젝트를 함께 쓰면, 그 앱에 가입한 계정으로도 게임에 로그인할 수 있어요. 게임 프로필은 게임에 처음 들어올 때 따로 만들어져요.

- **전적 기록 방식**: 전적은 각자의 브라우저가 기록해요. 마음먹으면 조작할 수 있는 구조라서, 친구끼리 즐기는 용도에 맞춰져 있어요.
- **로그인 없이 하기**: 컴퓨터와 하는 연습 게임은 로그인 없이도 돼요. 온라인 대전만 로그인이 필요해요.
- **앱스토어 출시**: Capacitor로 이 폴더를 안드로이드·iOS 앱으로 감쌀 수 있어요. 이때 카카오 로그인은 앱용 딥링크(커스텀 URL 스킴) 설정이 추가로 필요해요.
