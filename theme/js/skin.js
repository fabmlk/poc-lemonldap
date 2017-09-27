$(document).ready(function() {
  $("#MiSIV form").on("submit", function () {
      var $userInput = $(this).find("input[name='user']");
      var codetms = $(this).find("input[name='codetms']").val();

      $userInput.val($userInput.val() + '__' + codetms);
  });
});