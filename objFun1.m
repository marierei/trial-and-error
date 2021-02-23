function obj = objFun1(x)
% Følgende format er nødvendig på objektivfunksjonen for å kunne inludere
% den i flere av Matlabs optimaliseringsalgoritmer som vi kan bruke.

% x er en 1-dim vektor som inneholder alle xyz-posisjons-justeringer på de nodene som
% vi vil justere under optimaliseringen. 

% Resultatet fra funksjonen må kun være en skalar 
% Her er din kode som inneholder obj = 1*nedBoy + 0.001*maxE
% Definerer global variabel i dette scopet
global N;
global E;
global extF;
global extC;


for i = 1 : size(x,1)
    x(i,:) = rand(1,3);
end

x = x / 100;


T = zeros(size(N));


T(1,:) = N(1,:);
T(2,:) = N(2,:) - x(1,:);
T(3,:) = N(3,:);
T(4,:) = N(4,:) - x(2,:);
T(5,:) = N(5,:) - x(3,:);
T(6,:) = N(6,:);
T(7,:) = N(7,:);
T(8,:) = N(8,:) - x(4,:);
T(9,:) = N(9,:);
T(10,:) = N(10,:) - x(5,:);
T(11,:) = N(11,:) - x(6,:);


% Finner stress og displacement for ny matrise
[sE, dN] = FEM_truss(T,E, extF,extC);

maxE = maxEdgeLng(E,T);

nedBoy = dN(6,3);

%obj = nedBoy;
%obj = maxE;
obj = 1*nedBoy + 0.001*maxE;

end