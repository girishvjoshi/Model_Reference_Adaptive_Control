clear all
clc

wingrock = WingRock();
refModel = ReferenceModel();
mrac = MRAC(0.005);

sim_endTime = 50;
simTime = 0:wingrock.timeStep:sim_endTime;


% Progression Bar
ProgressBarFlag=1;
LimPB=(sim_endTime)/100/wingrock.timeStep;
HI=0;
llll=0;
PBBars='/';
Progressbar='0';

% Reference Signal
 XREF=zeros(length(simTime),1);
 XREF(3/wingrock.timeStep:7/wingrock.timeStep)=0;
 XREF(14/wingrock.timeStep:20/wingrock.timeStep)=1;
 XREF(25/wingrock.timeStep:30/wingrock.timeStep)=-1;

 recordTime = 0;

index=1; %this is a loop counter

for t = 0:wingrock.timeStep:sim_endTime
    
     xref=XREF(index); 
     refModel.propogateRefModel(xref);
     total_control = mrac.MRAC_CNTRL(wingrock.state,xref);
     wingrock.applyControl(total_control);
     recordTime = [recordTime,t];
     index = index + 1;
     
end

figure(1)
hold on
grid on
plot(recordTime,wingrock.recordSTATE(1,:));
plot(recordTime,refModel.recordSTATE(1,:));
plot(recordTime(1:end-1),XREF);
legend('x','x_rm','r(t)')

figure(2)
hold on; grid on;
plot(recordTime,wingrock.recordSTATE(2,:));
plot(recordTime,refModel.recordSTATE(2,:));
legend('x','x_rm')

figure(3)
hold on; grid on;
plot(recordTime,wingrock.recordTRUE_UNCERTAINTY);
plot(recordTime,mrac.recordADPTCNTRL);

 
