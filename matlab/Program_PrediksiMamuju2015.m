function Program_PrediksiMamuju2015(fileIn, completeOut, predicOut, varlat, varmsl, timeStart, timeEnd)

%Chaula Yoga Pradhika
%12913028

%Untuk menggunakan program ini, ubah:
%1. Nama file input data sesuai format matlab(load*.txt)
load(fileIn);
%Untuk menggunakan program ini, ubah:
%2. Deklarasi nilai data dari file input (A=*)
A=Data_MamujuEdit2015;
year=A(:,1);
month=A(:,2);
day=A(:,3);
hour=A(:,4);
minute=A(:,5);
second=A(:,6);
lapangan=A(:,7);

time=datenum(year,month,day,hour,minute,second);
%Untuk menggunakan program ini, ubah:
%3. Nilai lintang stasiun (lat=*)
lat = varlat;
%Untuk menggunakan program ini, ubah:
%4. Nilai muka air laut rerata stasiun (msl=* (satuan meter))
msl = varmsl;

%Untuk menggunakan program ini, ubah:
%5. Nama file output komponen pasut lengkap (Hasil_Complete_*.xls)
[NAME,FREQ,TIDECON,XOUT]=t_tide(lapangan,'internal',1,'START_TIME',time(1,1),...
	'latitude',lat,'output', completeOut);

%Untuk menggunakan program ini, ubah:
%6. Waktu awal untuk prediksi time1 (YYYY,MM,DD,hh,mm,ss) untuk awal prediksi
%dibuat panjang datanya sama kayak data lapangan
%misal harian tanggal 1 Januari 2015, data prediksi Januari 2015
%misal mingguan minggu 1 Januari 2015, prediksinya minggu 2 Januari 2015
%misal bulanan bulan Januari 2015, prediksinya Februari 2015
time1 = timeStart;
%Untuk menggunakan program ini, ubah:
%7. Waktu akhir untuk prediksi time2 (YYYY,MM,DD,hh,mm,ss) untuk akhir prediksi
%dibuat panjang datanya sama kayak data lapangan
%misal harian tanggal 1 Januari 2015, data prediksi Januari 2015
%misal mingguan minggu 1 Januari 2015, prediksinya minggu 2 Januari 2015
%misal bulanan bulan Januari 2015, prediksinya Februari 2015
time2 = timeEnd;
timepasut=time1:1/24:time2;

YOUT=t_predic(timepasut,NAME,FREQ,TIDECON,'latitude',lat);

pasut=transpose(YOUT)+msl;

%Untuk menggunakan program ini, ubah:
%8. Nama file output t_predic pasut (save Pasut_*.xls pasut -ascii)
save(predicOut, 'pasut', '-ascii');

%Data nilai variabel pasut ini yang digunakan untuk memprediksi elevasi
%untuk waktu-waktu lainnya