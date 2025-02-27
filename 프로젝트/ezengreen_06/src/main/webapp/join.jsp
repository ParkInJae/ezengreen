<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%
if(login != null)
{
	response.sendRedirect("index.jsp");
}
%>
<script>
window.onload = function () 
{
    document.join.uid.focus();

    $("#upwcheck").keyup(function () 
    {
        IsDuplicate = false;

        userpw = $("#upw").val(); // 비밀번호 입력값 가져오기
        userpwcheck = $("#upwcheck").val(); // 비밀번호 확인 입력값 가져오기

        if(userpwcheck == "") 
        {
            $("#spanMsg").html("비밀번호를 입력하세요.");
            return;
        }

        // 비밀번호와 비밀번호 확인값 비교하기
        if (userpw === userpwcheck) 
        {
            $("#spanMsg").html("비밀번호가 일치합니다.");
            $("#spanMsg").css("color", "blue");
        }else {
            $("#spanMsg").html("비밀번호가 일치하지 않습니다.");
            $("#spanMsg").css("color", "red");
        }
    });

    // 비밀번호 확인 입력란의 값이 변경될 때마다 비밀번호 일치 여부를 확인하는 함수 호출
    $("#upwcheck").trigger("keyup");
}
	
function Duplicate()
{	
	userid = $("#uid").val();
	//console.log(userid);
	$.ajax({
		type : "get",
		url: "idcheck.jsp?uid=" + userid,
		dataType: "html",
		success : function(result) 
		{
			result = result.trim();
			
			switch(result)
			{
			case "00":
				alert("아이디를 입력해주세요.");
				break;
			case "01":
				alert("중복된 아이디입니다.");
				IsDuplicate = true;
				break;					
			case "02":
				alert("사용 가능한 아이디입니다.");
				break;
			}
		}
	});
}
	
function SendMail()
{
	var umail = $("#umail").val();
	if( umail.indexOf("@") <= 0 )
	{
		alert("올바른 메일주소가 아닙니다.");
		$("#umail").focus();
		return;
	}
	$.ajax({
		type : "get",
		url: "sendmail.jsp?mail=" + umail,
		dataType: "html",
		success : function(result) 
		{
			result = result.trim();
			alert(result);
		}			
	});		
}
	
//회원가입 항목을 체크한다.
function DoJoin()
{
	if( document.join.uid.value == "" )
	{
		alert("아이디를 입력하세요.");
		document.join.uid.focus();
		return;
	}
	if( document.join.upw.value == "" )
	{
		alert("비밀번호를 입력하세요.");
		document.join.upw.focus();
		return;
	}
	if( document.join.upwcheck.value == "" )
	{
		alert("비밀번호를 입력하세요.");
		document.join.upwcheck.focus();
		return;
	}
	if( document.join.upw.value != document.join.upwcheck.value )
	{
		alert("비밀번호가 일치하지 않습니다.");
		document.join.upw.focus();
		return;
	}		
	if( document.join.uname.value == "" )
	{
		alert("이름을 입력하세요.");
		document.join.uname.focus();
		return;
	}
	if( document.join.umail.value == "" )
	{
		alert("이메일을 입력하세요.");
		document.join.uemail.focus();
		return;
	}
	if( document.join.emailcheck.value == "" )
	{
		alert("이메일 인증번호를 입력하세요.");
		document.join.emailcheck.focus();
		return;
	}		
	if( document.join.sign.value == "" )
	{
		alert("가입방지코드를 입력하세요.");
		document.join.sign.focus();
		return;
	}
	if( document.join.agree.value == "disagree" )
	{
		alert("약관에 동의해주세요.");
		return;
	}
	
    $.ajax({
        type: "get",
        url: "getemail.jsp",
        dataType: "html",
        success: function (result) {
            result = result.trim();
            if ($("#emailcheck").val() != result) {
                alert("이메일 인증번호가 일치하지 않습니다.");
                $("#emailcheck").focus();
            } else {
                // AJAX 호출을 통해 가입방지코드 확인
                $.ajax({
                    type: "get",
                    url: "getsign.jsp",
                    dataType: "html",
                    success: function (result) {
                        result = result.trim();
                        if ($("#sign").val() != result) {
                            alert("가입방지코드가 일치하지 않습니다.");
                            $("#sign").focus();
                        } else {
                            // 모든 검사 통과 시 확인 대화상자 표시
                            if (confirm("회원가입을 진행하시겠습니까?") == true) {
                                $("#join").submit();
                            }
                        }
                    }
                });
            }
        }
    });

    // 기본적으로 false를 반환하여 폼이 제출되지 않도록 합니다.
    return false;
}

function DoCancel()
{
	if(confirm("회원가입을 취소하시겠습니까?") == true)
	{
		document.location = "index.jsp";
	}
}

function viewpw() 
{
    eye.addEventListener('mousedown', (event) =>{
    	upw.type = 'text';
	});
    eye.addEventListener('mouseup', (event) =>{
    	upw.type = 'password';
	});
}

</script>
<form name="join" id="join" method="post" action="joinok.jsp">
	<table border="0" width="100%" height="430px" class="maintable">
		<tr height="25px">
			<td colspan="5" style="font-weight: bold;">회원가입 </td>
		</tr>
		<tr>
			<td colspan="5" height="1px">								
				<hr size="1" style="width: 100%; height: 1px; background-color: dimgrey">
			</td>
		</tr>
		<tr>
			<td rowspan="7" width="70px"></td>
		    <td width="140px">아이디(*)</td>
			<td colspan="2" >
				<input type="text" name="uid" id="uid" placeholder="아이디는 영문자로만 입력하세요." style="width:67%">
				<input type="button" onClick="Duplicate();" id="dump" name="dump" value="중복확인">
			</td>
			<td rowspan="6" width="140px"></td>
		</tr>
		<tr>
			<td>비밀번호(*)</td>
			<td colspan="2" >
				<input type="password" id="upw" name="upw" placeholder="비밀번호를 입력하세요." style="width:76%">
				<input type="button" value="보기" id="eye" name="eye" onClick="viewpw()">
			</td>
		</tr>
		<tr>
			<td>비번확인(*)</td>
			<td colspan="2" style="font-size: 10px;">
				<input type="password" name="upwcheck" id="upwcheck" placeholder="비밀번호를 입력하세요." style="width:93%">
				<br>
				<span id="spanMsg">비밀번호를 입력해주세요</span>
			</td>
		</tr>
		<tr>
			<td>성명(*)</td>
			<td colspan="2"><input type="text" name="uname" id="uname" placeholder="성명을 입력하세요." style="width:93%"></td>
		</tr>
		<tr>
			<td>이메일(*)</td>
			<td colspan="2">
				<input type="text" name="umail" id="umail" placeholder="ezen@ezen.com" style="width:57%">
				<input type="button" value="인증번호 받기" onClick="SendMail();">
			</td>
		</tr>
		<tr>
			<td>이메일 인증번호(*)</td>
			<td colspan="2" style="font-size: 10px;">
				<input type="text" name="emailcheck" id="emailcheck" placeholder="인증번호를 입력하세요." style="width:93%">
			</td>
		</tr>
		<tr>
			<td height="30px">가입방지코드</td>
			<td colspan="3">
				<img src="img.jsp" style="vertical-align: bottom">
				<input type="text" id="sign" name="sign" size="6">
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center">본인은 전북현대모터스의 팬임을 인정한다&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="agree" id="agree" value="agree">동의
				<input type="radio" name="agree" id="disagree" value="disagree" checked>비동의
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center">
				<input type="button" value="가입완료" id="joinAction_btn" onclick="DoJoin();">
				<input type="button" value="취소" onClick="DoCancel()">
			</td>
		</tr>
	</table>
</form>
<%@ include file="include/tail.jsp" %>