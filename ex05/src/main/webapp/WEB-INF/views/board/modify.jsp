<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>


<%@include file="../includes/header.jsp" %>

<style>
.uploadResult{
	width:100%;
	background-color:gray;
}
.uploadResult ul{
	display:flex;
	flex-flow:row;
	justify-content:center;
	align-items:center;
}
.uploadResult ul li{
	list-style:none;
	padding:10px;
	align-content:center;
	text-align:center;
}
.uploadResult ul li img{
	width:100px;
}
.uploadResult ul li span{
	color:white;
}
.bigPictureWrapper{
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 0%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255,255,255,0,5);
}
.bigPicture{
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}
.bigPicture img{
	width: 600px;
}
</style>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading"> Board Read Page</div>
			<div class="panel-body">
				<form action="/board/modify" method="post">
					<div class="form-group">
						<label>Bno</label> 
						<input class="form-control" name="bno" value="${board.bno }" readonly="readonly"/>
					</div>
					<div class="form-group">
						<label>Title</label> 
						<input class="form-control" name="title" value="${board.title }" />
					</div>
					<div class="form-group">
						<label>Text area</label> 
						<textarea rows="3" class="form-control" name="content" >${board.content }</textarea>
					</div>
					<div class="form-group">
						<label>Writer</label> 
						<input class="form-control" name="writer" readonly="readonly" value="${board.writer }">
					</div>
					<div class="form-group">
						<label>RegDate</label>
						<input class="form-control" name="RegDate"  value='<fmt:formatDate value="${board.regdate }" pattern="yyyy/MM/dd"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Update Date</label>
						<input class="form-control" name="updateDate"  value='<fmt:formatDate value="${board.updateDate }" pattern="yyyy/MM/dd"/>' readonly="readonly">
					</div>
					
					<input type="hidden" name="pageNum" value="${cri.pageNum }">
					<input type="hidden" name="amount" value="${cri.amount }">
					<input type="hidden" name="type" value="${cri.type}">
					<input type="hidden" name="keyword" value="${cri.keyword}">
					
					<button data-oper='modify' class="btn btn-default"  type="submit">Modify</button>
					<button data-oper='remove' class="btn btn-danger">Remove</button>
					<button data-oper='list' class="btn btn-info" >List</button>
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 첨부파일 -->
<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple="multiple">
				</div>
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div>>
<script type="text/javascript">
	$(document).ready(function () {
		
		var formObj = $("form");
		$('button').on("click", function (e) {
			e.preventDefault();
			var operation = $(this).data("oper");
			console.log(operation);
			if(operation === 'remove'){
				formObj.attr("action", "/board/remove");
			}else if(operation ==='list'){
				formObj.attr("action", "/board/list").attr("method", "get");
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(typeTag);
				formObj.append(keywordTag);
			}else if(operation === 'modify'){
				console.log("submit clicked");
				var str = "";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.dir(jobj);
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				formObj.append(str).submit();
			}
			formObj.submit();
		})
	})
	
	$(document).ready(function(){
		/* 첨부파일 리스트 조회 */
		(function(){
			var bno ='${board.bno}';
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
				console.log(arr);
				var str = "";
				$(arr).each(function(i, attach){
					if(attach.fileType){
						console.log(attach.fileType);
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'"+
						"data-type='"+attach.fileType+"'><div>";
						str += "<span>"+attach.fileName+"</span>";
						str += "<button type='button' data=file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>"+
							"<i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName="+fileCallPath+"'>";
						str += "</div>";
						str += "</li>";
					}else{
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'"+
						"data-type='"+attach.fileType+"'><div>";
						str += "<span>"+attach.fileName+"</span><br/>";
						str += "<button type='button' data=file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'>"+
						"<i class='fa fa-times'></i></button><br>";
						str += "<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
				})
				$(".uploadResult ul").html(str);
			});
		})();
		
		/* 첨부파일 x표시 이벤트 */
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			if(confirm("Remove this file?")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		})
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		/* 첨부파일 목록 변경시 이벤트 */
		$("input[type=file]").change(function(e){
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			for(var i = 0; i < files.length; i++){
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url:'/uploadAjaxAction',
				processData:false,
				contentType:false,
				data:formData,
				type:'post',
				dataType:'json',
				success:function(result){
					console.log(result);
					showUploadResult(result);
				}
			})
		})
		
		/* 첨부파일 저장 성공시 화면에 보여지는 이벤트 */
		function showUploadResult(uploadResultArr){
			
			if(!uploadResultArr || uploadResultArr.length == 0){return;}
			
			var uploadUL = $(".uploadResult ul");
			var str = "";
			
			$(uploadResultArr).each(function(i, obj){
				if(obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"'";
					str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str += "<span>"+obj.fileName+"</span>";
					str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='image'><i class ='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				}else{
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'><div>";
					str += "<span>" + obj.fileName + "</span>";
					str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='file'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div></li>";
				}
			})
			uploadUL.append(str);
		}
		
	});
	
	
</script>

<%@include file="../includes/footer.jsp" %>

