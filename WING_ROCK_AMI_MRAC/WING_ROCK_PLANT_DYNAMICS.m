function [x,x_rm] = WING_ROCK_PLANT_DYNAMICS(x,x_rm,r,dt,v,omega_rm,zeta_rm)

    
   xp=Reference_State_Model(x_rm,r,omega_rm,zeta_rm);
   %1
   rk1=dt*xp;
   x1=x_rm+rk1;
   %2
   xp=Reference_State_Model(x1,r,omega_rm,zeta_rm);
   rk2=dt*xp;
   x1=x_rm+2*rk2;
   %3
   xp=Reference_State_Model(x1,r,omega_rm,zeta_rm);
   rk3=dt*xp;
   x1=x_rm+2*rk3;
   %4
   xp=Reference_State_Model(x1,r,omega_rm,zeta_rm);
   rk4=dt*xp;
   
   x_rm=x_rm+(rk1+2.0*(rk2+rk3)+rk4)/6;
   
   clear xp x1 rk1 rk2 rk3 rk4
   
   xp_actual=Actual_State_Model(x,v);
   %1
   rk1=dt*xp_actual;
   x1=x+rk1;
   %2
   xp_actual=Actual_State_Model(x1,v);
   rk2=dt*xp_actual;
   x1=x+rk2;
   %3
   xp_actual=Actual_State_Model(x1,v);
   rk3=dt*xp_actual;
   x1=x+2*rk3;
   %4
   xp_actual=Actual_State_Model(x1,v);
   rk4=dt*xp_actual;
   
   x = x+(rk1+2.0*(rk2+rk3)+rk4)/6;
   

%% STATE Model
    function [x_dot_rm] = Reference_State_Model(x_rm,r,omega_rm,zeta_rm)
             x1Dot_rm = x_rm(2);
             x2Dot_rm = -omega_rm^2*x_rm(1)-2*zeta_rm*omega_rm*x_rm(2)+omega_rm^2*r;
             x_dot_rm=[x1Dot_rm;x2Dot_rm];
             
    function [x_dot] = Actual_State_Model(x,v)
             L_deltaa = 3;
             dx1 = (0.2314*x(1)+0.6918*x(2)-0.6245*abs(x(1))*x(2)+0.0095*abs(x(2))*x(2)+0.0214*x(1)^3);
             x1Dot = x(2);
             x2Dot =  dx1 + L_deltaa*v;
             x_dot=[x1Dot;x2Dot];
