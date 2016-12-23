/* global $, Stripe */

//Document ready
$(document).on('turbolinks:load', function(){
  var theForm = $('#pro_form');
  var submitBtn = $('#form-submit-btn');
  
  // Set Stripe publishable key
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  
  //When user clicks form submit btn
  submitBtn.click(function(event){
    
    //Prevent default submission behavior
    event.preventDefault();
    submitBtn.prop('disable', true).val("Processing");
    
    // Collect card fields
    var ccNum = $('#card_number').val(),
        cvcNum = $('#card_code').val(),
        expMonth = $('#card_month').val(),
        expYear = $('#card_year').val();
    
    // Use Stripe JS library to check for errors
    var error = false;
    
    // Validate card number
    if (!Stripe.card.validateCardNumber(ccNum)) {
      error = true;
      alert('The credit card appears to be invalid');
    }
    
    // Validate CVC code
    if (!Stripe.card.validateCVC(cvcNum)) {
      error = true;
      alert('The CVC code appears to be invalid');
    }
    
    // Validate card expiration date
    if (!Stripe.card.validateExpiry(expMonth, expYear)) {
      error = true;
      alert('The expiration date appears to be invalid');
    }
    
    
    if (error) {
      // If there are card errors, don't send to stripe
      submitBtn.prop('disable',false).val('Sign Up');
    } else {  
    
      // Send the card info to Stripe
      Stripe.createToken({
        number: ccNum,
        cvc: cvcNum,
        exp_month: expMonth,
        exp_year: expYear
      }, stripeResponseHandler);
    }
 });
 
 
   // Stripe will return a card token.
  function stripeResponseHandler(status,response) {
    var token = response.id; 
    
    //Inject card token as hidden field
    theForm.append($('<input="hidden" name="user[stripe_card_token]">').val(token));
    
    // Submit form to Rails app.
    theForm.get(0).submit();
    
  }

});

