% Funksjon som finner lengste edge i figuren
function L = maxEdgeLng(E,N)
% Rett fram, lett � forst� l�sning, kan forkortes og optimaliseres

maxL = 0;

for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer p� f�rste node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer p� andre node i edge nummer e
    xyzPosNode1 = N(nodeNr1,:); % xyz-pos til f�rste node i edge nummer e
    xyzPosNode2 = N(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm( xyzPosNode2 - xyzPosNode1); % Lengde p� edge nr e
    
    if lN > maxL
        maxL = lN;
    end
    
end

L = maxL;

end