// Catch the size of the print.  If it's not supported, tell the user and cancel the job
// Otherwise, print the job to the hold queue and give them instructions with cost.
// Curtis Adkins cadkins@systeloa.com (2025.10.30)

function printJobHook(inputs, actions) {
  
  // Paper size that is allowed
  var ALLOWED_PAPER_SIZE = [
    'LETTER',
    'LEGAL'
  ];
  
  //initialize the response variable to use later on
  var response = "";
  
  if (!inputs.job.isAnalysisComplete) {
    return;
  }
  
  // catch the error first!
  if (!ALLOWED_PAPER_SIZE.includes(inputs.job.paperSizeName)) {
    //user has printed an unsupported papersize.  Cancel the job and tell them it was canceled
    actions.log.error("User printed an unapproved paper size: " + inputs.job.paperSizeName);
    
    //var response = actions.client.promptOK("<html><span style='font-size:17pt;'>You have chosen a papersize that is not supported.  Please choose either Letter or Legal size paper.</span></html>");
    // send message to the user's client tool
    var response = actions.client.promptOK(
      "<html>"
      + "<div style='width:400px; height:200px; padding: 10px; color:#FFFFFF; background-color:#00AE5A;'>"
      + "  <div style='padding: 10px; font-weight: bold; font-size: 18px; text-align: center;'>"
      + "    Print Policy Alert<br>"
      + "    <img width='48' height='48' src='http://%PC_SERVER%/images/icons3/24x24/warning.png'>"
      + "  </div>"
      + "  <div style='font-size: 16pt; text-align: center;'>"
      + "   <p>The paper size chosen is not supported.  Please choose either Letter or Legal size paper and reprint your job.</p>"
      + "  </div>"
      + "</div><br>"
      + "</html>",{'hideJobDetails': true, 'dialogTitle': "Your job has been cancelled", 'dialogDesc' : "Your print job has been cancelled, please see below for details"});
    
    
    //user clicked OK.
    actions.job.cancel();  
    return;
    
  }else{
    // user chose papersize that is supported.  OK or Cancel print...
    // Inform the user of their classification
    var response = actions.client.promptOKCancel("<html><span style='font-size:17pt;'>Please visit a Print release device in the <b>COPY CENTER</b> to retrieve your Print Job!</span></html>");
    if (response == "OK") {
      // Add your action code here for clicking OK
      actions.log.debug("Enter info here for user");
      
    } else if (response == "CANCEL") {
      //cancel job
      actions.job.cancel();
    } else if (response == "TIMEOUT") {
      
      // Add your action code here for timeout
      actions.job.cancel();
    }
  }
}

​