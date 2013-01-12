// Load the SDK Asynchronously
(function(d){
   var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement('script'); js.id = id; js.async = true;
   js.src = "//connect.facebook.net/en_US/all.js";
   ref.parentNode.insertBefore(js, ref);
 }(document));


function login() {
  FB.login(function(response) {
      if (response.authResponse) {
        // connected
        window.location.href = AUTH_URL;
      } else {
        // cancelled
      }
  });
}

$(function(){
  $("#login-button").click(login);
});