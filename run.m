setUpFigWind(2);

N = [2 2 2
     2 3 2
     3 2 2
     3 3 2
     
     2 3 2.5
     3 2 2.5
     2 2 2.5
     3 3 2.5
     
     %3 4 5
     %2 4 4
     %4 5 5
     
     
     2 2 3];
N = N / 10;
 
E = [1 2
     2 3
     3 1
     1 4
     2 4
     3 4
     
     4 5
     
     2 5
     3 5
     5 6
     1 6
     4 6
     1 7
     2 7
     6 7
     5 7
     5 8
     6 8
     7 9
     8 9
     5 9
     6 9]

r = 0.003; %meter
E(:,3) = pi*r^2


extC = [1 1 0
        0 0 0
        0 0 0
        0 0 0
        
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        
        1 1 1];

extF = [0 0 0
        0 0 0
        0 0 0
        0 0 0
        
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        
      -10 0 10];

[sE, dN] = FEM_truss(N, E, extF, extC)

figure(1);clf;plotMesh(N,E,'txt')

hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(N,extF, 0.001);

figure(2);clf;plotMesh(N,E); % evt. plotMesh(N,E,'txt');
visuellScale = 100;
% plotter over mesh med overderevne node displacement 
hold on;plotMesh(N-visuellScale*dN,E,'col',[1 0 0]); 
% plotter ekserne krefter
hold on;plotMeshFext(N-visuellScale*dN,extF, 0.001);