TITLE "LOAN INTEREST MODEL";

proc import datafile="\\Client\C$\Users\piyus\Desktop\Work\MS\Sem 3\Data Visualization\Project\data\loan_dummies.csv" out=data1 dbms=csv replace;
getnames=yes;
run;
proc contents data=data1;
run;

proc reg plots=none data=data1; 
model annual_inc = int_rate;
model int_rate = annual_inc;
model emp_length_10__years = int_rate;
model int_rate = emp_length_10__years;
model funded_amnt = int_rate; 
model int_rate = funded_amnt;
model grade_B = int_rate; 
model int_rate = grade_B;
model grade_C = int_rate;
model int_rate = grade_C;
model home_ownership_MORTGAGE = int_rate;
model int_rate = home_ownership_MORTGAGE;
model home_ownership_RENT = int_rate;
model int_rate = home_ownership_RENT;
model inq_0_0 = int_rate;
model int_rate = inq_0_0;
model inq_1_0 = int_rate;
model int_rate = inq_1_0;
model installment = int_rate;
model int_rate = installment;
model loan_amnt = int_rate;
model int_rate = loan_amnt;
model purpose_credit_card = int_rate;
model int_rate = purpose_credit_card;
model purpose_debt_consolidation = int_rate;
model int_rate = purpose_debt_consolidation;
model term__36_months = int_rate;
model int_rate = term__36_months;
model tot_cur_bal = int_rate;
model int_rate = tot_cur_bal;
model total_acc = int_rate;
model int_rate = total_acc;
model verification_status_Source_Verif = int_rate;
model int_rate = verification_status_Source_Verif;
model verification_status_Verified = int_rate; 
model int_rate = verification_status_Verified;
run;

proc reg plots=none data=data1; 
model int_rate = annual_inc emp_length_10__years funded_amnt grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
output p=pred r=resid; 
run; 
proc gplot; 
plot pred*resid/VREF=0; 
run;

*3 problematic features - funded_amnt, installment, loan_amnt*;

proc reg plots=none data=data1; 
model funded_amnt = annual_inc emp_length_10__years grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
model loan_amnt = annual_inc emp_length_10__years funded_amnt grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
model installment = annual_inc emp_length_10__years funded_amnt grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
run;

*model funded_amnt working best*;

proc corr;
var annual_inc emp_length_10__years funded_amnt grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified; 
run;

*funded_amnt remove*;
proc reg plots=none data=data1; 
model int_rate = annual_inc emp_length_10__years grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
*output p=pred r=resid;*; 
run;

*Take log of tot_cur_bal and annual_inc*;
data data2;
set data1;
ln_tot_cur_bal = log(tot_cur_bal);
ln_annual_inc = log(annual_inc);
run;

proc reg plots=none data=data2; 
model int_rate = ln_annual_inc emp_length_10__years grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 installment loan_amnt purpose_credit_card purpose_debt_consolidation term__36_months ln_tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
*output p=pred r=resid;*; 
run;

*take ratio loan_amnt to installment*;
data data3;
set data2;
loan_amnt_inst = loan_amnt/installment;
run;
proc reg plots=none data=data3; 
model int_rate = ln_annual_inc emp_length_10__years grade_B grade_C home_ownership_MORTGAGE home_ownership_RENT inq_0_0 inq_1_0 loan_amnt_inst purpose_credit_card purpose_debt_consolidation term__36_months ln_tot_cur_bal total_acc verification_status_Source_Verif verification_status_Verified/vif tol stb collin; 
*output p=pred r=resid;*; 
run;

quit;
