//restrict paper sizes

function printJobHook(inputs, actions) {
  
  
  // Paper size that is allowed
  var ALLOWED_PAPER_SIZE = [
    'LETTER',
    'LEGAL'
  ];
  
  if (!inputs.job.isAnalysisComplete) {
    // No job details yet so return.
    return;
  }
  
  
  if (!ALLOWED_PAPER_SIZE.includes(inputs.job.paperSizeName)) {
    //do whatever actions here that you want when someone prints an
    //unapproved paper size
    actions.log.error("User printed an unapproved paper size: " + inputs.job.paperSizeName);
    actions.job.cancel();  
  }else{
    //same here...just maybe log it or nothing at all?
    actions.log.error("User paper size: " + inputs.job.paperSizeName);
  }
  
}​