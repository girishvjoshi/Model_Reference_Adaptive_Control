function [sigma] = SIGMA_RBF(x,RBF_C,n2,mu)

for index = 1:n2
    sigma(index) = (1/(sqrt(2*pi)*mu))*exp(-norm(RBF_C(:,index)-x)^2/(2*mu^2));
end
end