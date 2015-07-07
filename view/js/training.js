//alert("Hello World");
$("document").ready(function(){
	$("#wait").css("display", "none");
	$(document).ajaxStart(function() {
		//$("#content").addClass("wait");
		$("#wait").css("display", "block");
	});
	$(document).ajaxComplete(function() {
		$("#wait").css("display", "none");
		//$("#content").removeClass("wait");
	});
	$.ajax({
		type: "GET",
		url: "/perl/training/login",
		success: function(data) {
			$('#content').html(data);
		},
		error: function(error) {
			alert("Failed to fetch please contact dinesh");
			console.log(error);
		}
	});
	$(document).on('click','.signin-btn', function(){
		$.ajax({
			type: "GET",
			url: "/training/signup.html",
			success: function(data) {
				$('#content').html(data);
			},
			error: function(error) {
				alert("Failed to fetch please contact dinesh");
				console.log(error);
			}
		});
	});
	$(document).on('click','.login-btn', function(){
		$.ajax({
			type: "GET",
			url: "/training/login.html",
			success: function(data) {
				$('#content').html(data);
			},
			error: function(error) {
				alert("Failed to fetch please contact dinesh");
				console.log(error);
			}
		});
	});

	$(document).on('click','.topic-link',function(){
		$.ajax({
			type: "GET",
			url: $(this).attr("href"),
			success: function(data) {
				$('#content').html(data);
			},
			error: function(error) {
				alert("Failed to fetch please contact dinesh");
				console.log(error);
			}
		});
	});
	//callback handler for form submit
	$(document).on('submit',"#ajaxForm",function(e)
	{
		e.preventDefault();
		var postData = $(this).serializeArray();
		var newPassword, errorFlag = false;
		$.each(postData,function(i,x){
			if( x.name == "newPassword" ){
				newPassword = x.value;
			}
			else if ( newPassword && x.name == "password" ){
				if( newPassword !== x.value ){
					alert("Password not matched" + newPassword + " " + x.value);
					errorFlag = true;
				}
			}
		});
		if( errorFlag ){
			e.preventDefault();
			return false;
		}
		var formURL = $(this).attr("action");
		$.ajax(
			{
				url : formURL,
				type: "POST",
				data : postData,
				success:function(data, textStatus, jqXHR) 
				{
					$("#content").html(data);
				},
				error: function(jqXHR, textStatus, errorThrown) 
				{
					alert("Error submitting the form contact dinesh");
					console.log(errorThrown);
				}
			});
			e.preventDefault(); //STOP default action
			//e.unbind(); //unbind. to stop multiple form submit.
	});
	$("#ajaxForm").submit(); //Submit  the FORM
});

