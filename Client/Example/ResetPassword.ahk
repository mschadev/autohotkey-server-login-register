#include ../ServerLib.ahk
License := new Server("test1234","test1234")
MsgBox,% License.ResetPassword()