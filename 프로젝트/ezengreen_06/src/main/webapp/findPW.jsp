<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<script>
function findPW()
{
	if( document.findpw.uid.value == "" )
	{
		alert("아이디를 입력하세요.");
		document.findpw.uid.focus();
		return false;
	}
	if( document.findpw.uemail.value == "" )
	{
		alert("이메일을 입력하세요.");
		document.findpw.uemail.focus();
		return false;
	}
	if( document.findpw.emailcheck.value == "" )
	{
		alert("이메일 인증번호를 입력하세요.");
		document.findpw.emailcheck.focus();
		return false;
	}
	
	$.ajax({
        type: "get",
        url: "findPWEmail.jsp",
        dataType: "html",
        data: {
        	uid: document.findpw.uid.value,
            uemail: document.findpw.uemail.value
        },
        success: function (result) 
        {
            result = result.trim();
            switch(result) 
            {
                case "00":
                    alert("잘못된 입력입니다.");
                    break;
                case "02":
                    alert("회원가입한 아이디가 없습니다.");
                    break;
                default:
                    $.ajax({
                        type: "get",
                        url: "getemail.jsp",
                        dataType: "html",
                        success: function(result) {
                            result = result.trim();
                            if ($("#emailcheck").val() != result) 
                            {
                                alert("이메일 인증번호가 일치하지 않습니다.");
                                $("#emailcheck").focus();
                            }else
                            {
                            	if (confirm("비밀번호 재설정을 진행하시겠습니까?")==true) 
                                {
                                    document.findpw.submit();
                                }
                            }
                        }
                    });
                    break;
            }
        }
    });

    return true;
}

function email()
{
	var dto = {
			
	}
	uid = $("#uid").val();
	uemail = $("#uemail").val();
	if( uemail.indexOf("@") <= 0 )
	{
		alert("올바른 메일주소가 아닙니다.");
		$("#uemail").focus();
		return;
	}
	$.ajax({
		type : "get",
		url: "sendmail.jsp",
		data:{
			mail: uemail,
			uid: uid
		},
		dataType: "html",
		success : function(result) 
		{
			result = result.trim();
			alert(result);
		}			
	});
}

</script>
<form name="findpw" name="findpw" method="post" action="resetPW.jsp">
	<table border="0" width="100%" height="430px" hclass="n-table" style="background-color: #f0f0f0;">
		<tr style="height: 20px;">
			<td colspan="4"></td>
		</tr>
		<tr height="25px">
			<td colspan="4" style="font-weight: bold;">&nbsp;비밀번호 찾기 </td>
		</tr>
		<tr>
			<td colspan="4" height="1px">								
				<hr size="1" style="width: 98%; height: 1px; background-color: dimgrey">
			</td>
		</tr>
		<tr class="aaaa">
			<td colspan="4"></td>
		</tr>
		<tr class="aaaa">
			<td width="100px"></td>
			<td colspan="3" style="font-weight: bold; font-size: 13px;">가입한 이메일로 인증</td>
		</tr>
		<tr class="aaaa" >
			<td width="100px"></td>
			<td colspan="3" style="font-size: 10px;">가입한 이메일 주소와 입력한 이메일 주소가 같아야, 인증번호를 받을 수 있습니다.</td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td colspan="4"></td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td style="font-weight: bold; font-size: 13px;"> 아이디</td>
			<td>
				<input id="uid" name="uid" align="left" size="35" style="font-weight: bold; font-size: 13px;" placeholder="아이디를 입력해주세요">
			</td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td style="font-weight: bold; font-size: 13px;"> 이메일주소</td>
			<td>
				<input id="uemail" name="uemail" align="left" size="35" style="font-weight: bold; font-size: 13px;" placeholder="ezen@ezen.com">
				<input type="button" value="인증번호 받기" onClick="email();">
			</td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td style="font-weight: bold; font-size: 13px;"> 인증번호</td>
			<td>
				<input type="text" id="emailcheck" name="emailcheck" size="35" style="font-weight: bold; font-size: 13px;" placeholder="인증번호 숫자 6자리 입력">
			</td>
		</tr>
		<tr style="height:40px;">
			<td colspan="5" align="center">
				<input type="button" value="완료" onClick="findPW();">&nbsp;
				<input type="button" value="취소" onClick="history.back()">
			</td>
		</tr>
		<tr>
			<td colspan="5"></td>
		</tr>
	</table>     	
</form>	    
<%@ include file="include/tail.jsp" %>