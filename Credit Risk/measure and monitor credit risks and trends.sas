/* Load credit portfolio data */
data credit_portfolio;
   infile 'credit_portfolio.csv' delimiter=',' firstobs=2;
   input client_id $ credit_limit exposure credit_losses;
   format credit_limit dollar12.2 exposure dollar12.2 credit_losses dollar12.2;
run;

/* Calculate credit risk metrics */
proc means data=credit_portfolio noprint;
   var exposure credit_losses;
   output out=credit_risk_metrics sum=total_sum mean=total_mean;
run;

/* Calculate credit risk ratios */
data credit_risk_ratios;
   set credit_risk_metrics;
   credit_loss_ratio = credit_losses / exposure;
run;

/* Generate monthly and quarterly credit risk reports */
%macro generate_credit_risk_report(report_period);
   /* Filter data based on report period */
   data credit_risk_report;
      set credit_risk_ratios;
      where report_period = "&report_period.";
   run;

   /* Prepare report */
   title "Credit Risk Report for &report_period.";
   proc print data=credit_risk_report noobs;
   run;
   title;

   /* Export report to PDF */
   ods pdf file="Credit_Risk_Report_&report_period..pdf";
   proc print data=credit_risk_report noobs;
   run;
   ods pdf close;
%mend;

/* Generate monthly and quarterly reports */
%generate_credit_risk_report(January);
%generate_credit_risk_report(February);
%generate_credit_risk_report(March);
%generate_credit_risk_report(Q1);
%generate_credit_risk_report(April);
%generate_credit_risk_report(May);
%generate_credit_risk_report(June);
%generate_credit_risk_report(Q2);
/* ... and so on for subsequent months and quarters */

/* Email reports to Senior Management and the Board of Directors */
%macro email_reports(email_recipients);
   %do i = 1 %to %sysfunc(countw(&email_recipients));
      %let recipient = %scan(&email_recipients, &i);
      filename email EMAIL "&recipient."
         SUBJECT="Monthly and Quarterly Credit Risk Reports"
         ATTACH=("Credit_Risk_Report_January.pdf" "Credit_Risk_Report_February.pdf" "Credit_Risk_Report_March.pdf" /* ... and so on for other months and quarters */)
         CONTENT_TYPE="application/pdf";
      data _null_;
         file email;
         put "Please find attached the monthly and quarterly credit risk reports.";
      run;
   %end;
%mend;

/* Specify email recipients and send reports */
%email_reports("seniormanager1@example.com manager2@example.com");
%email_reports("boardmember1@example.com boardmember2@example.com");
