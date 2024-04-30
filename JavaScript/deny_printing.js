/*
Script will take any user that is not in the "APPROVED_USERS" array and deny them printing.
It will cancel the job and log it as a warning in the "Logs" section of PaperCut interface

*/


function printJobHook(inputs, actions) {
  var APPROVED_USERS =["peter.parker", "bruce.wayne", "tony.stark"];
  var SUBJECT = "You printed to a restricted printer";
  var BODY = "The device you tried to print to is restricted.  If you feel this is in error, please contact IT";
  
  if (!inputs.job.isAnalysisComplete) {
    // No job details yet so return.
    return;
  }
  
  
  for(var i=0; i<APPROVED_USERS.length;i++){
    if(inputs.user.username === APPROVED_USERS[i]){
      return true;
    }else{
      actions.job.cancelAndLog('Printing to this device is not allowed for user: ' + inputs.job.username);
      actions.log.warning('A user that was not approved, tried to print to device: ' + inputs.job.username);
	  // if you want to email the user: 
	  // just add a variable for SUBJECT and BODY
	  // actions.utils.sendEmail(inputs.user.email,SUBJECT,BODY);
    }
  }
}

