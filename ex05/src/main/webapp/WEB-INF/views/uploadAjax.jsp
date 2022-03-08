<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<style type="text/css">
.uploadResult{
	width:100%;
	background-color: gray;
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
	width:200px;
}

.uploadResult ul li span{
	color:white;
}

.higPictureWrapper{
	position:absolute;
	display:none;
	justify-content:center;
	align-items:center;
	top:0%;
	width:100%;
	height:100%;
	background-color:gray;
	z-index:100;
	backround:rgba(255,255,255,0.5);
}

.bigPicture{
	position:relative;
	display:flex;
	justify-content:center;
	align-items:center;
}

.bigPicture img{
	width:600px;
}

</style>
</head>
<body>
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	<h1>Ajax</h1>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
		
	<div class="uploadResult">
		<ul>
		</ul>
		
	</div>
	<button id="uploadBtn">Upload</button>
	
	
	
	
	
<script type="text/javascript">
	function showImage(fileCallPath){
		
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%', height:'100%'}, 1000);
	}

	$(document).ready(function(){
		/* 첨부파일 x버튼 이벤트 */
		$(".uploadResult").on("click","span",function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);
			
			$.ajax({
				
				url:'/deleteFile',
				data:{fileName: targetFile, type:type},
				dataType:'text',
				type:'POST',
				success:function(result){
					alert(result);
				}
			});
		});
		
		
		/* 클릭하여 커진 파일화면 닫기 */
		$(".bigPictureWrapper").on("click", function(e){
			
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			setTimeout(() =>{
				$(this).hide();
			},1000);
		})
		
		
		/* 파일업로드 결과 */
		var uploadResult = $(".uploadResult ul");
		function showuploadedFile(uploadResultArr){
			var str = "";
			$(uploadResultArr).each(function(i, obj){
				if(!obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/img/attach.png'>" + obj.fileName + "</li>";
				}else{
					/* str += "<li>" + obj.fileName + "</li>"; */
					
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g),'/');
					console.log(fileCallPath)
					
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"+
						"<span data-file=\'"+fileCallPath+"\' data-type='image'>x</span></li>";
				}				
			})
			uploadResult.append(str);
		}
		
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		
		/* 파일 유효성검사 */
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
		
		var cloneObj = $(".uploadDiv").clone();
		
		/* 파일 업로드 버튼 이벤트 */
		$("#uploadBtn").on("click", function(e){
			var formData = new FormData();
			var inputFile = $("input[name=uploadFile]");
			var files = inputFile[0].files;
			
			for(var i = 0; i < files.length; i++){
				if(!checkExtension(files[i].naem, files[i].size)){
					return;
				}
					formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url:'/uploadAjaxAction',
				processData:false,
				contentType:false,
				data:formData,
				type:'post',
				success:function(result){
					console.log(result);
					showuploadedFile(result);
					$(".uploadDiv").html(cloneObj.html());
				}
			});
		});
	});
	
</script>
</body>
</html>