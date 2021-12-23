%%%% PF_Contoh.m %%%%
% Memplot kurva Efficient Frontier
% Grafik Mean_Variansi dan Grafik Mean_Standar Deviasi
clc
%%%%% PF_Implied_Risk_Free_Contoh %%%%
clc 
%data 2019 harian
% mu = [ 0.00025229	0.00199808	0.00097746	0.00036391	0.00162373 ]'
% C = [ 0.00019116	0.00000960	0.00003402	0.00005939	0.00000366 ;
%       0.00000960	0.00152507	-0.00000165	0.00026464	0.00002614 ;
%       0.00003402	-0.00000165	0.00009063	0.00004016	0.00002369 ; 
%       0.00005939	0.00026464	0.00004016	0.00069367	0.00007353 ;
%       0.00000366	0.00002614	0.00002369	0.00007353	0.00040172 ]

%data 2020 harian
mu = [ -0.00093361	-0.001760276	-0.000158511	0.00316966	0.000526276 ]'
C = [0.00043779	0.00026550	0.00019285	0.00031725	0.00018550 ;
    0.00026550	0.00141714	0.00029493	0.00075885	0.00025462 ;
    0.00019285	0.00029493	0.00047252	0.00039300	0.00016367 ;
    0.00031725	0.00075885	0.00039300	0.00198140	0.00027545 ;
    0.00018550	0.00025462	0.00016367	0.00027545	0.00045380 ]

PF_periksadata(C, 1.e-6) ;
[alpha0, alpha1, beta0, beta2, h0, h1,] = PF_EFMVcoeff(mu, C)
figure(1)
PF_EFMVplot(0.0, 0.5, 0.01, alpha0, alpha1, beta0, beta2) ; %% Grafik Mean_Variansi
figure(2)
PF_EFMSDplot(0.0, 0.5, 0.01, alpha0, alpha1, beta0, beta2) ; % Mean_Standar Deviasi

%%%% PF_periksadata.m %%%%
% Memeriksa apakah matriks C simetri dan definit positif ?

function PF_periksadata(C,tol)
format compact
if norm(C - C') > tol
    hasil = 'Error : matriks kovariansi tidak simetri'
    tindakan = 'Tekan Ctrl+C untuk melanjutkan'
    pause
    return
end
if min(eig(C)) < tol
    hasil = 'Error : matriks kovariansi tidak definit positif '
    tindakan = 'Tekan Ctrl+C untuk melanjutkan'
    pause
    return
end
end

%%%% PF_EFMVcoeff %%%%
% Menentukan koefisien-koefisien kurva Efficient Frontier

function [alpha0, alpha1, beta0, beta2, h0, h1] = PF_EFMVcoeff(mu,C)
n = length(mu) ; e11 = ones(1,n)' ;
temp1 = C^-1 * e11; temp2 = temp1' * e11;
h0 = temp2^-1 * temp1 ;
temp3 = C^-1 * mu; temp4 = e11' * temp3;
h1 = C^-1 * mu - temp4 * h0 ;
alpha0 = mu' * h0 ;
alpha1 = mu' * h1 ;
beta0 = h0' * C * h0 ;
beta2 = h1' * C * h1 ;
end

%%% % PF_EFMVplot.m %%%%
% Memplot Grafik Mean_Variansi (Ekspektasi vs Variansi Portofolio)

function PF_EFMVplot(t_bawah,t_atas,delta_t,alpha0,alpha1,beta0,beta2)
t = t_bawah : delta_t : t_atas;
mup = alpha0 + t * alpha1;
mup_bawah = alpha0 - t * alpha1;
sigma2p = beta0 + t.^2 * beta2;
plot(sigma2p,mup,'-k',sigma2p,mup_bawah,'--k')
xlabel('Variansi Portofolio \sigma_p^2')
ylabel('Ekspektasi Portofolio \mu_p')
title('Efficient Frontier: Ekspektasi vs Variansi Portofolio','Fontsize',12)
text(beta0,alpha0,'\leftarrow {\rm portofolio yang memiliki nilai variansi terkecil}')

% Menentukan sumbu koordinat
xmin = 0.;
xmax = beta0 + t_atas.^2 * beta2;
ymin = alpha0 - t_atas*alpha1;
ymax = alpha0 + t_atas*alpha1;
axis([xmin xmax ymin ymax])
end

%%%% PF_EFMSDplot %%%%
% Memplot Grafik Mean_Standar Deviasi (Ekspektasi vs Standar Deviasi Portofolio)

function PF_EFMSDplot(t_bawah, t_atas, delta_t, alpha0, alpha1, beta0, beta2)
t = t_bawah : delta_t : t_atas ;
mup = alpha0 + t * alpha1 ;
mupbawah = alpha0 - t * alpha1 ;
stddevp = ( beta0 + t.^2 * beta2 ) .^0.5 ;
beta_05 = sqrt(beta0);
plot ( stddevp, mup, 'k', stddevp, mupbawah, 'k--' )
xlabel('Standard Deviasi Portofolio \sigma_p')
ylabel('Ekspektasi Portofolio \mu_p')
title('Efficient Frontier: Ekspektasi vs Standard Deviasi Portofolio','Fontsize',12)
text(beta_05,alpha0,'\leftarrow {\rm portofolio yang memiliki nilai standard deviasi terkecil}')

% Menentukan sumbu koordinat
xmin = 0. ;
xmax = ( beta0 + t_atas .^2 * beta2 ) .^0.5 ;
ymin = alpha0 - t_atas * alpha1 ;
ymax = alpha0 + t_atas * alpha1 ;
axis ( [ xmin xmax ymin ymax ] )
end

%  n = length(mu) ; e11 = ones(1,n)' ;
%  r = 0.0563
%  xmarket = (C^-1*(mu-r*e11))/(e11'*C^-1*(mu-r*e11))
%  returnmarket = mu'*xmarket
%  sigmarket = sqrt(xmarket'*C*xmarket)
