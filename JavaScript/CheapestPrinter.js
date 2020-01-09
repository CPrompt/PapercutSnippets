function printJobHook(inputs, actions) {
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
  
  // Check to see if the user is currently running the client software
  if (inputs.client.isRunning) {
    
    // Add your code if the client is running
    // The list of printers that are compatible with each other.
    // i.e. they support the same printer language and features.
    var COMPATIBLE_PRINTERS = [
      "50-1933\\FindMe"
    ];
    
    // Calculate the cost for each printer.
    var cheapestPrinter = "";
    var cheapestCost = inputs.job.cost;
    
    for (i = 0; i < COMPATIBLE_PRINTERS.length; i++) {
      var cost = inputs.job.calculateCostForPrinter(COMPATIBLE_PRINTERS[i]);
      actions.log.debug("Cost for: " + COMPATIBLE_PRINTERS[i] + " is: " + inputs.utils.formatCost(cost));
      
      if (cost < cheapestCost) {
        // Found a cheaper printer.
        cheapestPrinter = COMPATIBLE_PRINTERS[i];
        cheapestCost = cost;
      }
    }
    
    if (cheapestPrinter == "") {
      // No cheaper printer, this one is the cheapest.
      actions.log.debug("Current printer is cheapest.");
      
    } else {
      // We've found a cheaper printer.
      actions.log.debug("Cheapest printer is: " + cheapestPrinter);
      
      var saving = inputs.job.cost - cheapestCost;
      
      // Ask the user whether to print on the cheapest printer.
      var response = actions.client.promptYesNoCancel(
        "<html>Printing this job on printer <b>'" + cheapestPrinter
        + "'</b> will cost <b>" + inputs.utils.formatCost(cheapestCost) + "</b> "
        + "saving a total of <b>" + inputs.utils.formatCost(saving) + "</b>.<br><br>"
        + "Would you like this job to be printed on <b>'" + cheapestPrinter + "'</b>?</html>");
      
      if (response == "CANCEL" || response == "TIMEOUT") {
        // Cancel the job and exit the script.
        actions.job.cancel();
        return;
      }
      
      if (response == "YES") {
        
        // User selected "YES", so perform the redirect to cheapest printer.
        // We recalculate the cost of the job on the destination printer.
        actions.job.redirect(cheapestPrinter, {
          "recalculateCost" : true
        });
        
        // Inform the user that the job is redirected.
        actions.client.sendMessage("Your job is being printed on '" + cheapestPrinter + "'");
      }
    }
    
  } else {
    
    // Add your code if the client is NOT running
    actions.log.error("The user " + inputs.job.username + " is NOT running the client software!");
  }
  
}// end function printJobHook