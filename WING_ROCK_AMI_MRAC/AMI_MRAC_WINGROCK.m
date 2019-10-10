%% CONSTANTS

clear all; clc
t0=0;%initial time
tf=50;%final time in seconds
dt=0.01;%simulation time step in seconds
t=t0:dt:tf;

ProgressBarFlag=1;
LimPB=(tf-t0)/100/dt;
HI=0;
llll=0;
PBBars='/';
Progressbar='0';

%%
x = [1;1];%intial state
e_tot = 0;

%% reference model parameters

x_rm = x; 
w_hat = zeros(5,1);
gamma = 1.0;
L_deltaa_hat = 3;
mu =1.5;
RBF_C = [linspace(-1.5,1.5,5);linspace(-1.5,1.5,5)];

%% plotting array initialization 

index=1;        %this is a loop counter
T_REC        = zeros(length(t),1);
X_REC        = zeros(length(t),1);
XDOT_REC     = zeros(length(t),1);
D_REC = zeros(length(t),1);
U_REC = zeros(length(t),1);
W_REC = zeros(5,length(t));
XREF_REC        = zeros(length(t),1);
XREFDOT_REC     = zeros(length(t),1);

%% Reference Signal
% Reference model parameters

omegan_rm = 2;        % reference model natural freq (deg/s)
zeta_rm   = 0.5;        % reference model damping ratio
v_ad = 0;
Wstar=[0.2314 0.6918 -0.6245 0.0095 0.0214]';% the parameters of the wingrock uncertainty
Kp = 2.5; Kd = 2.5; Ki = [0 0]; %Ki = [0.5 10];

A=[0 1;-Kp -Kd];
B = [0; 1];
Q = eye(2);
P = lyap(A',Q);%A' instead of A because need to solve A'P+PA+Q=0
p=0;
[Lp,PP,E] = lqr(A,B,eye(2)*100,1);

% v_crm=omegan_rm^2*(XREF(1)-x_rm(1))-2*zeta_rm*omegan_rm*x_rm(2);
 XREF=zeros(length(t),1);
 XREF(3/dt:7/dt)=0;
 XREF(14/dt:20/dt)=1;
 XREF(25/dt:30/dt)=-1;
 
 %%
%  PHI_O = @(x,y)[x;y;abs(x)*y;abs(y)*y;x^3];
 PHI = @(x,y)[x;y;abs(x)*y;abs(y)*y;x^3];
%  RBF = @(x,RBF_C,mu)((1/(sqrt(2*pi)*mu))*exp(-(norm(RBF_C-x))^2/(2*mu^2)));
 
 for t=0:dt:tf
   %% 
%    PHI = [1;RBF(x,RBF_C(:,1),mu);RBF(x,RBF_C(:,2),mu);RBF(x,RBF_C(:,3),mu);RBF(x,RBF_C(:,4),mu);RBF(x,RBF_C(:,5),mu)];
    e=x_rm-x;%compute reference model error
    e_tot = e_tot + e;
    xref=XREF(index); 
    v_crm = omegan_rm^2*(xref-x_rm(1))-2*zeta_rm*omegan_rm*x_rm(2);
    v_pd = [Kp Kd]*e; 
    v_Int = Ki*e_tot;
    w_hat = w_hat+(-gamma*PHI(x(1),x(2))*e'*P*B + 0*gamma*eye(length(w_hat))*(Wstar-w_hat));
%     w_hat = w_hat+(-gamma*PHI*e'*P*B);
    v_ad = w_hat'*PHI(x(1),x(2));
%     v_ad = w_hat'*PHI;
    v = v_pd+v_crm+0*v_Int-v_ad;
    delta_a = (1/L_deltaa_hat)*v;
    [x,x_rm]= WING_ROCK_PLANT_DYNAMICS(x,x_rm,XREF(index),dt,delta_a,omegan_rm,zeta_rm);
          
    %%
    T_REC(index)     = t;
    
    X_REC(index)     = x(1);
    XDOT_REC(index)  = x(2);
    ERR_REC(:,index) = e;
    XREF_REC(index)     = x_rm(1);
    XREFDOT_REC(index)  = x_rm(2);
    D_REC(index) = Wstar'*PHI(x(1),x(2));
%     D_REC(index) = Wstar'*PHI_O(x(1),x(2));
    DHAT_REC(index) = v_ad;
    W_REC(:,index) = w_hat;
    WSTAR_REC(:,index) = Wstar;
    U_REC(index) = v;
      

     index = index+1;   
     
        cccc=index-(HI*LimPB);
    
    if cccc==LimPB
        HI=HI+1;
        llll=int2str(HI);
        clear Progressbar;
        Progressbar=[];
        for iii=1:HI
            Progressbar=[Progressbar PBBars];
        end
        clc;
        Progressbar=[Progressbar llll '%']
        
    end
    
end
AMI_MRAC_PLOTS;



