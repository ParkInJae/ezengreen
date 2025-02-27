<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%
String nowpage = request.getParameter("page");
if(login == null )
{
	response.sendRedirect("index.jsp");
	return;
}
%>
<script>
//----------------------------------------------------------------------------------------
	
	window.onload = function()
	{
		document.g_write.title.focus();
		//첨부파일 추가 버튼 이벤트 리스너
		$("#btnAdd").click(function(){
			AddAttach();
		});
		
		AddAttach();
	}
	
	//첨부파일 추가
	function AddAttach()
	{
		$.ajax({
			url : "attach.jsp",
			type : "get",
			dataType : "html",
			success : function(response){
				response = response.trim();
				$("#tblUpload").append(response);
			}
		});				
	}
	
	//첨부파일 삭제 
	function RemoveAttach(obj)
	{
		var tr = $(obj).parent().parent();
		tr.remove();
	}

//스마트 에디터---------------------------------------------------------------------------
let oEditors = []

smartEditor = function()
{
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "content",
		sSkinURI: "../SmartEditor2/SmartEditor2Skin.html",
		fCreator: "createSEditor2",
		htParams : 
		{
			// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseToolbar : true,
			// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : false,
			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true, 
	 	}
	});
};

$(document).ready(function()
{
	smartEditor();
});

function submitPost()
{
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD",[]);
	let content = document.getElementById("content").value ;
	let title = $("#title").val();
	let fileInput = document.getElementById("attach");
	let files = fileInput.files;
			
	if(title === "")
	{
		alert("제목을 입력해주세요.");
		document.getElementById('title').focus();
		return false;
	} 
	if(content === "<p>&nbsp;</p>")
	{ 
		alert("내용을 입력해주세요.");
		oEditors.getById["content"].exec("FOCUS");
		return false;
	}
	if(files.length === 0 )
	{
		alert("갤러리게시판은 이미지 첨부가 필수입니다.");
		return false;
	}
	
    // 파일데이터 담기
    for (var i = 0; i < filesArr.length; i++) 
    {
        // 삭제되지 않은 파일인지 확인
        if (!filesArr[i].is_delete) 
        {	// 삭제되지 않은 파일만 attach_file 키에 추가
            formData.append("attach_file", filesArr[i]);
        }
    }
	
	let confirmSubmit = confirm("작성하시겠습니까?");
	return confirmSubmit;
}

//스마트 에디터---------------------------------------------------------------------------

function cancel()
{
	let confirmSubmit = confirm("작성을 취소하시겠습니까?");
	
	if(confirmSubmit) 
	{
		history.back();
	}
	return confirmSubmit;
}
</script>
<style>
.maintable > *
{
	font-size : 10pt;
	background-color : white;
}
</style>
<form id="g_write" name="g_write" action="writeok.jsp?page=<%= nowpage %>" enctype="multipart/form-data" method="post" onsubmit="return submitPost();">
	<table border="0" width="100%" height="430px" style="text-align:center" class="maintable">
		<input type="hidden" id="bkind" name="bkind" value="G">
		<tr>
			<td colspan="5" align="left">
				<b style="float:left; font-size: 14pt; font-weight: 900;">&nbsp;갤러리 - 글쓰기</b>
			</td>
		</tr>
		<tr>
			<td colspan="3" height="1px">								
				<hr size="1" style="width: 99%; height: 1px; background-color: dimgrey">
			</td>
		</tr>
		<tr>
			<td width="75px">글쓰기 :</td>
			<td colspan="4" align="left"><input type="text" id="title" name="title" style="width: 98%" placeholder="제목을 입력해주세요"></td>
		</tr>
			<td width="75px">내용 :</td>
			<td colspan="4" height="200px" align="left">
				<textarea name="content" id="content" rows="15" cols="77"></textarea>
			</td>	                			
			<tr>
				<td style="font-size:10pt" width="75px"><input type="button" id="btnAdd" name="btnAdd" value="파일추가"></td> 
				<td id="tblUpload"></td>   				
			</tr>
			<tr>
				<td colspan="4">
					<input type="submit" value="작성하기" id="writeAction_btn">
					<input type="button" value="취소" onClick="cancel()">
				</td>
			</tr>
	</table>
</form>
<%@ include file="include/tail.jsp" %>
