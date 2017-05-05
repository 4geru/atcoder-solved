$(function(){
    $("#submit-comment").click(function(){
        var request = $.ajax({
            type: "get",
            url: "/aor",
            async: false
        }).done(function(result) {  
            console.log(request.responseText);
 
        })
    });
});