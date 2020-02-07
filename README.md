# Autohotkey-Server-Login-Register

서버 연동해서 손쉽게 로그인,회원가입할 수 있는 라이브러리입니다.

## ServerLib_A.ahk와 ServerLib.ahk차이

ServerLib_A.ahk는 관리자 용 라이브러리 이고 ServerLib.ahk는 일반 사용자 용 라이브러리입니다.

# 설치

## 클라이언트

1.  스크립트에 ServerLib.ahk을 포함시킵니다.

```Autohotkey
#include ServerLib.ahk
```

2.  관리자용 프로그램은 ServerLib_A.ahk까지 포함해야합니다.

## 서버

1.  members.sql을 이용해 테이블을 생성합니다.
2.  includes\config.php파일에 상수를 수정합니다.
3.  pdo가 활성화되어 있어야 합니다.
4.  권장버전은 5.6이상입니다.

# 예제

## 로그인

```Autohotkey
#include ServerLib.ahk
License := new Server("test1234","test1234")
MsgBox,% License.Login()
```

## 회원가입

```Autohotkey
#include ../ServerLib.ahk
License := new Server("test1234","test1234")
MsgBox,% License.Register("test","test1@test1.com")
```

# 개발 환경

PHP 7.0 <br>
Apache 2.2 <br>
Autohotkey 1.1.30.01

# 라이센스

[MIT](./LICENSE)
