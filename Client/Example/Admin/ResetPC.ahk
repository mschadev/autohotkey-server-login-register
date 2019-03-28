#include ../../ServerLib.ahk
#include ../../ServerLib_A.ahk
License := new Server_A("ID","PW")
MsgBox,% License.ResetPC("test1234")