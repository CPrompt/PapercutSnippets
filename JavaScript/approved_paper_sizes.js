  
function printJobHook(inputs, actions) {
  
  
  if (!inputs.job.isAnalysisComplete) {
    // Full job details are not yet available. Return and wait to be called again.
    return;
  }
  
  var APPROVED_PAPER_SIZES = [
	"Letter",
	"Legal"
  ];
  
  if (inputs.job.paperSizeName(APPROVED_PAPER_SIZES)){
	  actions.log.error("User tried to print " + inputs.job.paperSizeName + " and it was canceled");
	  actions.job.cancel();
  }
 }  