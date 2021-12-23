%% PF_frontcon_MeanVariance
clf
clc
% Masukan :
% mu = [ 0.15 0.2 0.08 ] ; % Return masing-masing saham
% C = [ 0.2 0.05 -0.01 ; 0.05 0.3 0.015 ; ...
% -0.01 0.015 0.1 ] ; % Matriks Kovariansi return saham
% mu = [ 1.1900 1.1300 1.0900 1.1500 0.9050 ]'
% 
% C = [ 0.0277 -0.0208 -0.0012 0.0094 -0.0244 ;
%       -0.0208 0.0357 0.0037 -0.0039 0.0109 ;
%       -0.0012 0.0037 0.0121 0.0017 0.0039 ;
%       0.0094 -0.0039 0.0017 0.0072 -0.0064 ;
%       -0.0244 0.0109 0.0039 -0.0064 0.0341 ]
mu = [ 0.000252286	-0.000302889	0.000977461	0.000363915	0.00022183 ]'

C = [ 0.00019116	0.00004378	0.00003402	0.00005939	0.00003465 ;
0.00004378	0.00019366	0.00004010	0.00006702	0.00005966 ;
0.00003402	0.00004010	0.00009063	0.00004016	0.00005878 ;
0.00005939	0.00006702	0.00004016	0.00069367	0.00011609 ;
0.00003465	0.00005966	0.00005878	0.00011609	0.00020655 ]
NumPorts = 10;  
% Keluaran :
p = Portfolio;
p = setAssetMoments(p, mu, C);
p = setDefaultConstraints(p);

plotFrontier(p, NumPorts);
% 
% [ sigma_PF , mu_PF , y ] = frontcon( mu , C , 10 ) ;
% 
% % Menampilkan tabel hasil proporsi investasi saham , return portofolio dan resiko portofolio nya
% disp(' y mu_PF Sigma_PF')
% disp([y , mu_PF, sigma_PF])
% [ y , mu_PF , sigma_PF ]
% 
% % Menampilkan kurva the efficient frontier
% frontcon ( mu , C , 10 )

%% PF_Menggunakan_portcons
% clc
NSaham = 5 ; % Banyaknya Saham
BatasBawahNilaiProporsi_y = [ 0.5 0.5 0.5 0 0.5 ];
BatasAtasNilaiProporsi_y = [ 1 1 1 1 1 ] ;
Kelompok = [ 0 0 0 0 0 ; 0 0 0 0 0 ] ;
BatasBawahNilaiProporsiKelompok_y = [ 0 0 ] ;
BatasAtasNilaiProporsiKelompok_y = [ 1 1 ] ;
MatriksKendala = portcons ( 'Default' , NSaham , ...
'AssetLims' , BatasBawahNilaiProporsi_y, BatasAtasNilaiProporsi_y , NSaham, ...
'GroupLims' , Kelompok , BatasBawahNilaiProporsiKelompok_y ,...
BatasAtasNilaiProporsiKelompok_y )

%% PF_Menggunakan_portopt
% clc
%PF_Menggunakan_portcons ;
%data 2019 harian
% mu = [ 0.00025229	0.00199808	0.00097746	0.00036391	0.00162373 ]'
% C = [ 0.00019116	0.00000960	0.00003402	0.00005939	0.00000366 ;
%       0.00000960	0.00152507	-0.00000165	0.00026464	0.00002614 ;
%       0.00003402	-0.00000165	0.00009063	0.00004016	0.00002369 ; 
%       0.00005939	0.00026464	0.00004016	0.00069367	0.00007353 ;
%       0.00000366	0.00002614	0.00002369	0.00007353	0.00040172 ]

%data 2019 harian dgn riskfree
% mu = [ 0.00025229	0.00199808	0.00097746	0.00036391	0.00162373 0.00015425 ]'
% C = [ 0.00019116	0.00000960	0.00003402	0.00005939	0.00000366 0 ;
%       0.00000960	0.00152507	-0.00000165	0.00026464	0.00002614 0 ;
%       0.00003402	-0.00000165	0.00009063	0.00004016	0.00002369 0 ;
%       0.00005939	0.00026464	0.00004016	0.00069367	0.00007353 0 ;
%       0.00000366	0.00002614	0.00002369	0.00007353	0.00040172 0 ;
%       0             0           0           0           0          0 ]

%data 2020 harian
mu = [ -0.00093361	-0.001760276	-0.000158511	0.00316966	0.000526276 ]'
C = [0.00043779	0.00026550	0.00019285	0.00031725	0.00018550 ;
    0.00026550	0.00141714	0.00029493	0.00075885	0.00025462 ;
    0.00019285	0.00029493	0.00047252	0.00039300	0.00016367 ;
    0.00031725	0.00075885	0.00039300	0.00198140	0.00027545 ;
    0.00018550	0.00025462	0.00016367	0.00027545	0.00045380 ]

%data 2020 harian dgn risk free
% mu = [ -0.00093361	-0.001760276	-0.000158511	0.00316966	0.000526276 0.00011644]'
% C = [0.00043779	0.00026550	0.00019285	0.00031725	0.00018550 0 ;
%     0.00026550	0.00141714	0.00029493	0.00075885	0.00025462 0 ;
%     0.00019285	0.00029493	0.00047252	0.00039300	0.00016367 0 ;
%     0.00031725	0.00075885	0.00039300	0.00198140	0.00027545 0 ;
%     0.00018550	0.00025462	0.00016367	0.00027545	0.00045380 0 ;
%     0           0           0           0           0          0 ]




% NumPorts = 100;  
[ sigma_PF, mu_PF, y ] = portopt ( mu, C, 30) ;
disp('mu_PF , Sigma_PF')
disp([mu_PF, sigma_PF])
y
plot( sigma_PF, mu_PF)
xlabel('Resiko (Standar Deviasi Return Portofolio)')
ylabel('Ekspektasi Return Portofolio')
title('Kurva Efisien Frontier')