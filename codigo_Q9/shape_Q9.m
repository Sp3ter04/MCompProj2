function N=shape_Q9(ksi,eta);

    N(1)=(1/4)*(ksi^2-ksi)*(eta^2-eta);
    N(2)=(1/4)*(ksi^2+ksi)*(eta^2-eta);
    N(3)=(1/4)*(ksi^2+ksi)*(eta^2+eta);
    N(4)=(1/4)*(ksi^2-ksi)*(eta^2+eta);
    N(5)=(1/2)*(1-ksi^2)*(eta^2-eta);
    N(6)=(1/2)*(ksi^2+ksi)*(1-eta^2);
    N(7)=(1/2)*(1-ksi^2)*(eta^2+eta);
    N(8)=(1/2)*(ksi^2-ksi)*(1-eta^2);
    N(9)=(1-ksi^2)*(1-eta^2);
end