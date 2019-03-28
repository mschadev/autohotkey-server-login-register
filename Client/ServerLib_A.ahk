;어드민 전용
class Server_A extends Server
{
    __New(ID,PW){
        base.__New(ID,PW)
    }
    __Delete(){

    }
    ResetPC(ID){
        winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        URL := this._URL "Admin/ResetPC.php"
        winHttp.Open("POST",URL)
        winHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        winHttp.SetRequestHeader("User-Agent","System-"this._Name "-adminrequest")

        postData := "id=" ID "&"
        postData .= "securitycode=" this.SHA512(this.MakeSecurityCode() "System-" this._Name "-adminrequest" "adminrequest")
        winHttp.SetRequestHeader("Content-Length",StrLen(postData))
        winHttp.Send(postData)
        winHttp.WaitForResponse()

        Result := winHttp.ResponseText
        Result := Trim(Result)
        IfInString, Result, 정상처리
        {
            return True
        }
        else{
            MsgBox,%Result%
            return false
        }
    }
    License(ID,Datetime){
        winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        URL := this._URL "Admin/ReLicense.php"
        winHttp.Open("POST",URL)
        winHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        winHttp.SetRequestHeader("User-Agent","System-"this._Name "-adminrequest")

        postData := "id=" ID "&"
        postData .= "datetime=" Datetime "&"
        postData .= "securitycode=" this.SHA512(this.MakeSecurityCode() "System-" this._Name "-adminrequest" "adminrequest")
        winHttp.SetRequestHeader("Content-Length",StrLen(postData))
        winHttp.Send(postData)
        winHttp.WaitForResponse()

        Result := winHttp.ResponseText
        Result := Trim(Result)
        IfInString, Result, 정상처리
        {
            return True
        }
        else{
            MsgBox,%Result%
            return false
        }
    }
}