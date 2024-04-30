/*
* Limit the number of pages a user can print
* If the limit is reached, deny the job and
* send an email to the admin email address
* as well as send an email to the end user
*/

function printJobHook(inputs, actions) {
  
  var LIMIT = 10;  // Show message for jobs over 100 pages.
  var ADMIN_EMAIL = "gbo.systel@gmail.com";  //admin email to send report to
  
  /*
  * This print hook will need access to all job details
  * so return if full job analysis is not yet complete.
  * The only job details that are available before analysis
  * are metadata such as username, printer name, and date.
  *
  * See reference documentation for full explanation.
  */
  if (!inputs.job.isAnalysisComplete) {
    // No job details yet so return.
    return;
  }
  
  if (inputs.job.totalPages > LIMIT) {
    
    //check if the client is running
    if(inputs.client.isRunning){
      //job is larger than the limit
      //send a message to the client
      var response = actions.client.promptOK(
        "<html>"
        + "<div style='width:400px; height:240px; padding: 10px; color:#FFFFFF; "
        + "    background-color:#00AE5A;'>"
        + "  <div style='padding: 10px; font-weight: bold; font-size: 18px; text-align: center;'>"
        + "    Print Policy Alert<br>"
        + "    <img src='http://%PC_SERVER%/images/client-logo.png'>"
        + "  </div>"
        + "  <div style='font-size: 10px; text-align: center;'>"
        + "   This print job is above the maximum number of pages"
        + "   that can be printed.<br><br>"
        + "   Please submit your document to Print Shop.<br><br>"
        + "  </div>"
        + "</div><br>"
        + "</html>",{'hideJobDetails': true, 'dialogTitle': "Your job has been cancelled", 'dialogDesc' : "Your print job has been cancelled, please see below for details"});
      
      //cancel the job and log
      actions.job.cancelAndLog("Job exceeded maximum number of pages. Cancelled, user directed to Job Ticketing.");
      //notify the admin
      actions.utils.sendEmail(ADMIN_EMAIL, "Large print job", inputs.user.username + " tried to print a large job and it was canceled")
        return;
    }else{
      //client isn't running so send an email only
      //cancel job and log
      actions.job.cancelAndLog("Job exceeded maximum number of pages. Cancelled, user directed to Job Ticketing.");
      //notify the admin
      actions.utils.sendEmail(ADMIN_EMAIL, "Large print job", "User tried to print a large job and it was canceled")
        //notify the user
        actions.utils.sendEmail(inputs.user.email, "Large print job notice", "Your print job exceeded the limit.  Please send large print jobs to the print shop.")
        return;
    }
  }
}


