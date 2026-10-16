/*
* Change the timeout period for held jobs for specific group
*/
function printJobHook(inputs, actions) {
 
  if (!inputs.job.isAnalysisComplete) {
    // No job details yet so return.
    return;
  }
 
  // The user group we need to adjust the hold time for
  var USER_TIME_ADJUSTMENT = "ENTER_GROUP_HERE";
  var timeoutMins = 4320; //set to 72 hours
  var default_timeoutMins = 240; //designate the default timeout which is 4 hours.
 
  if(inputs.user.isInGroup(USER_TIME_ADJUSTMENT)){
    actions.job.setHoldReleaseTimeout(timeoutMins);
    actions.log.info("A print job was set to 72 hours for " + inputs.job.username);
  }else{
    actions.log.info("Print job is default");
    actions.job.setHoldReleaseTimeout(default_timeoutMins);
  }
}