--1.Sorgu
SELECT * FROM `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality` LIMIT 100;

--2.Sorgu yıllara göre toplam doğum sayısı
select Year, 
sum(Births) as toplam_dogum_sayisi
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by Year
order by Year;

--3. Sorgu istenilen sorguyu kaydetmek için kredi hesabı girilmeliymiş :/
select * 
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
where Births > 20000;

--4. Sorgu: Anne yaşı 30'dan büyük olanlara 1, diğerlerine 0 atanarak yeni bir sütun eklenmesi

select *,
(case when Ave_Age_of_Mother > 30 then 1 else 0 end) as yas_30dan_buyuk_mu
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
where (case when Ave_Age_of_Mother > 30 then 1 else 0 end)= 1;

-- bunun yerine 
with my_cte as (
  select *,
(case when Ave_Age_of_Mother > 30 then 1 else 0 end) as yas_30dan_buyuk_mu
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
)

, another_cte as(
select * from my_cte
where yas_30dan_buyuk_mu = 1
)

SELECT * FROM another_cte;

--5. Sorgu en çok doğum yapan ili bulmak
select County_of_Residence, sum(Births) as total_births
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by County_of_Residence
order by total_births desc;

--6. Sorgu genel ortalama doğum ağırlığı

select round(avg(Ave_Birth_Weight_gms), 2) as average_birth_weight
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`;


--7. Sorgu annenin yıllara göre yaşının 30'dan büyük olduğu doğum sayısı ve oranı
select 
extract(Year from Year) as year,
sum(Births) as total_births,
sum(case when Ave_Age_of_Mother > 30 then Births else 0 end) as greater_than_30,
round(( sum(case when Ave_Age_of_Mother > 30 then Births else 0 end)/ sum(Births)),2) as ratio
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by year
order by ratio desc;

-- 8. Sorgu eyaletlere göre doğum yapan annelerin ortalama yaşı
select County_of_Residence,
round(avg(Ave_Age_of_Mother), 2) as average_mothers_age
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by County_of_Residence
order by average_mothers_age;
-- 9. Sorgu annenin yaşının en küçük değerine ait bilgilerin getrilmesi
select * 
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
order by Ave_Age_of_Mother
limit 1;

--alternatif
with min_age as(
select min(Ave_Age_of_Mother) as minn_age
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`)

select *
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
where Ave_Age_of_Mother = (select minn_age from min_age);

-- 10.Sorgu yıllara göre ortalam gebelik süresi

select
extract(Year from Year) as year,
round(avg(Ave_OE_Gestational_Age_Wks),2) as average_gestational_age
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by year
order by year;

-- 11. Sorgu yıllara göre vücut kitle oranlarındaki değişimler
select
extract(Year From Year) as year,
round(avg(Ave_Pre_pregnancy_BMI
),2) as average_BMI
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by year
order by year;

-- 12. Sorgu annenin vücut kütle indeksiyle bebeğin kilosu arasındaki ilişki
select 
extract(Year From Year) as year,
round(avg(Ave_Pre_pregnancy_BMI),2) as average_BMI,
round(avg(Ave_Birth_Weight_gms),2) as average_birth_weight
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by year;

-- 13.en ağır bebeğin bilgilerinin bulunması
select *
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
order by Ave_Birth_Weight_gms desc
limit 1;

--14. annenin yaşına göre toplam doğum sayısı
select ROUND(Ave_Age_of_Mother) AS rounded_age,
sum(Births) as births
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by rounded_age
order by births desc;

-- 15. Sorgu 39 haftadan fazla doğum sayısı
select count(*) as total_births_over_39_weeks
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
where Ave_OE_Gestational_Age_Wks >39;

-- 16. Sorgu gebelik süresiyle bebek kilosu arasındaki ilişki
select 
round(avg(Ave_Birth_Weight_gms),2) as avg_weight,
round(Ave_LMP_Gestational_Age_Wks) as avg_gestation
from `bigquery-public-data.sdoh_cdc_wonder_natality.county_natality`
group by  avg_gestation;
