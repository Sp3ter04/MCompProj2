function dN=diff_shape_T6(ksi,eta)

    dN = [
    4*ksi + 4*eta - 3, 4*eta + 4*ksi - 3; 
    4*ksi - 1, 0;                       
    0, 4*eta - 1;                      
    -4*(2*ksi + eta - 1), -4*ksi;        
    4*eta, 4*ksi;                                            
    -4*eta, -4*(2*eta + ksi - 1);       
    ];
end
