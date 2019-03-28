# Autohotkey-Server-Login-Register
서버 연동해서 손쉽게 로그인,회원가입할 수 있는 라이브러리입니다.

# ServerLib_A.ahk와 ServerLib.ahk차이
ServerLib_A.ahk는 관리자 용 라이브러리 이고 ServerLib.ahk는 일반 사용자 용 라이브러리입니다.
# 설치
 1. 스크립트에 ServerLib.ahk을 포함시킵니다.
 ```Autohotkey
#include ServerLib.ahk
 ```
 2. 관리자용 프로그램은 ServerLib_A.ahk까지 포함해야합니다.


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
# 라이센스
[라이센스](https://github.com/zxc010613/Autohotkey-Server-Login-Register/blob/master/LICENSE)
