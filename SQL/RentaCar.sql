--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15rc2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Kullanici; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Kullanici";


ALTER SCHEMA "Kullanici" OWNER TO postgres;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: aracarttir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aracarttir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE toplamsayilar set aracsayisi=aracsayisi+1;
    RETURN new;
END;
$$;


ALTER FUNCTION public.aracarttir() OWNER TO postgres;

--
-- Name: aracsorgu(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aracsorgu(plakano character varying) RETURNS TABLE(plakasi character varying, km integer, modelkodu character varying, modeli character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT
        "public"."arac"."plaka",
        "public"."arac"."km",
        "public"."AracModeli"."modelKodu",
        "public"."AracModeli"."ad"
    FROM
        "arac"
    JOIN "AracModeli" ON "arac"."modelKodu" = "AracModeli"."modelKodu"
    WHERE
        "public"."arac"."plaka" ILIKE plakano ;
END; $$;


ALTER FUNCTION public.aracsorgu(plakano character varying) OWNER TO postgres;

--
-- Name: iptalrezervasyonfunction(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.iptalrezervasyonfunction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

        INSERT INTO "iptalrezervasyon"("rezervasyonNo", "kullaniciNo", "zaman")
        VALUES(OLD."rezervasyonno", OLD."kullanicino", CURRENT_TIMESTAMP::TIMESTAMP);
        RETURN OLD;
        
END;
$$;


ALTER FUNCTION public.iptalrezervasyonfunction() OWNER TO postgres;

--
-- Name: kmplakaara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kmplakaara(kmara integer) RETURNS TABLE(kmsi integer, plakasi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "km", "plaka" FROM "arac"
                 WHERE "km" < kmara;
END;
$$;


ALTER FUNCTION public.kmplakaara(kmara integer) OWNER TO postgres;

--
-- Name: kullaniciara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kullaniciara(kullanicinu integer) RETURNS TABLE(numarasi integer, adi character varying, soyadi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "kullaniciNo", "ad", "soyad" FROM "Kullanici"."Kullanici"
                 WHERE "kullaniciNo" = kullaniciNu;
END;
$$;


ALTER FUNCTION public.kullaniciara(kullanicinu integer) OWNER TO postgres;

--
-- Name: musteriarttir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.musteriarttir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE toplamsayilar set musterisayisi=musterisayisi+1;
    RETURN new;
END;
$$;


ALTER FUNCTION public.musteriarttir() OWNER TO postgres;

--
-- Name: musterigirisi(character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.musterigirisi(adi character varying, soyadi character varying, tc character varying, eposta character varying, tel character varying, sifre character varying, kullanici character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE kullaniciNo integer;

BEGIN

INSERT INTO "Kullanici"."Kullanici"("ad","soyad","TCkimlikNo","epostaAdresi","telNo","sifre","kullaniciTipi")
VALUES (adi, soyadi, tc, eposta, tel, sifre, kullanici) RETURNING "kullaniciNo" INTO kullanicino;
INSERT INTO "Kullanici"."Musteri"("kullaniciNo", "musteriNo")
VALUES (kullanicino,DEFAULT);


END 
$$;


ALTER FUNCTION public.musterigirisi(adi character varying, soyadi character varying, tc character varying, eposta character varying, tel character varying, sifre character varying, kullanici character varying) OWNER TO postgres;

--
-- Name: plakaEkle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."plakaEkle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."plaka" = UPPER(NEW."plaka"); -- büyük harfe dönüştürdükten sonra ekle
    NEW."plaka" =replace (NEW."plaka", ' ', ''); -- Önceki ve sonraki boşlukları temizle
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."plakaEkle"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Kullanici; Type: TABLE; Schema: Kullanici; Owner: postgres
--

CREATE TABLE "Kullanici"."Kullanici" (
    "kullaniciNo" integer NOT NULL,
    ad character varying(40) NOT NULL,
    soyad character varying(40) NOT NULL,
    "TCkimlikNo" character varying(11) NOT NULL,
    "epostaAdresi" character varying(40) NOT NULL,
    "telNo" character varying(10) NOT NULL,
    sifre character varying(40) NOT NULL,
    "kullaniciTipi" character varying(20) DEFAULT 'Musteri'::character varying NOT NULL
);


ALTER TABLE "Kullanici"."Kullanici" OWNER TO postgres;

--
-- Name: Kullanici_kullaniciNo_seq; Type: SEQUENCE; Schema: Kullanici; Owner: postgres
--

CREATE SEQUENCE "Kullanici"."Kullanici_kullaniciNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Kullanici"."Kullanici_kullaniciNo_seq" OWNER TO postgres;

--
-- Name: Kullanici_kullaniciNo_seq; Type: SEQUENCE OWNED BY; Schema: Kullanici; Owner: postgres
--

ALTER SEQUENCE "Kullanici"."Kullanici_kullaniciNo_seq" OWNED BY "Kullanici"."Kullanici"."kullaniciNo";


--
-- Name: musterisayaci; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.musterisayaci
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.musterisayaci OWNER TO postgres;

--
-- Name: Musteri; Type: TABLE; Schema: Kullanici; Owner: postgres
--

CREATE TABLE "Kullanici"."Musteri" (
    "kullaniciNo" integer NOT NULL,
    "musteriNo" text DEFAULT ('M00'::text || nextval('public.musterisayaci'::regclass)) NOT NULL
);


ALTER TABLE "Kullanici"."Musteri" OWNER TO postgres;

--
-- Name: Personel; Type: TABLE; Schema: Kullanici; Owner: postgres
--

CREATE TABLE "Kullanici"."Personel" (
    "kullaniciNo" integer NOT NULL,
    "personelNo" character varying(10) NOT NULL
);


ALTER TABLE "Kullanici"."Personel" OWNER TO postgres;

--
-- Name: musteriSayac; Type: SEQUENCE; Schema: Kullanici; Owner: postgres
--

CREATE SEQUENCE "Kullanici"."musteriSayac"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Kullanici"."musteriSayac" OWNER TO postgres;

--
-- Name: AracModeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AracModeli" (
    "modelKodu" character varying(10) NOT NULL,
    marka character varying(3) NOT NULL,
    ad character varying(20) NOT NULL,
    guc integer NOT NULL,
    "guncelTutar" integer NOT NULL,
    vites character varying(3) NOT NULL,
    yakit character varying(3) NOT NULL
);


ALTER TABLE public."AracModeli" OWNER TO postgres;

--
-- Name: arac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arac (
    "aracNo" integer NOT NULL,
    plaka character varying(10) NOT NULL,
    km integer NOT NULL,
    renk character varying(5) NOT NULL,
    "durumKod" character varying(1) NOT NULL,
    "modelKodu" character varying(10) NOT NULL
);


ALTER TABLE public.arac OWNER TO postgres;

--
-- Name: Arac_aracNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Arac_aracNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Arac_aracNo_seq" OWNER TO postgres;

--
-- Name: Arac_aracNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Arac_aracNo_seq" OWNED BY public.arac."aracNo";


--
-- Name: Durum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Durum" (
    "durumKodu" character varying(1) NOT NULL,
    ad character varying(10) NOT NULL
);


ALTER TABLE public."Durum" OWNER TO postgres;

--
-- Name: Marka; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Marka" (
    "markaKodu" character varying(3) NOT NULL,
    ad character varying(40) NOT NULL
);


ALTER TABLE public."Marka" OWNER TO postgres;

--
-- Name: Odeme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Odeme" (
    "OdemeNo" integer NOT NULL,
    "toplamTutar" integer NOT NULL,
    tarih date NOT NULL,
    "odemeyontemNo" character varying(4) NOT NULL
);


ALTER TABLE public."Odeme" OWNER TO postgres;

--
-- Name: Odeme Yontem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Odeme Yontem" (
    "odemeYontemNo" character varying(4) NOT NULL,
    "odemeYontemi" character varying(20) NOT NULL
);


ALTER TABLE public."Odeme Yontem" OWNER TO postgres;

--
-- Name: Odeme_OdemeNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Odeme_OdemeNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Odeme_OdemeNo_seq" OWNER TO postgres;

--
-- Name: Odeme_OdemeNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Odeme_OdemeNo_seq" OWNED BY public."Odeme"."OdemeNo";


--
-- Name: Renk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Renk" (
    "renkKodu" character varying(5) NOT NULL,
    renk character varying(20) NOT NULL
);


ALTER TABLE public."Renk" OWNER TO postgres;

--
-- Name: rezervasyon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezervasyon (
    rezervasyonno integer NOT NULL,
    baslangictarihi date NOT NULL,
    bitistarihi date NOT NULL,
    kullanicino integer NOT NULL
);


ALTER TABLE public.rezervasyon OWNER TO postgres;

--
-- Name: Rezervasyon_rezervasyonNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rezervasyon_rezervasyonNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Rezervasyon_rezervasyonNo_seq" OWNER TO postgres;

--
-- Name: Rezervasyon_rezervasyonNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rezervasyon_rezervasyonNo_seq" OWNED BY public.rezervasyon.rezervasyonno;


--
-- Name: Sigorta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sigorta" (
    "sigortaKodu" character varying(3) NOT NULL,
    ad character varying(15) NOT NULL,
    "ücreti" integer NOT NULL,
    detay text
);


ALTER TABLE public."Sigorta" OWNER TO postgres;

--
-- Name: Vites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Vites" (
    "vitesKodu" character varying(2) NOT NULL,
    vites character varying(20) NOT NULL
);


ALTER TABLE public."Vites" OWNER TO postgres;

--
-- Name: Yakit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Yakit" (
    "yakitKodu" character varying(3) NOT NULL,
    yakit character varying(10) NOT NULL
);


ALTER TABLE public."Yakit" OWNER TO postgres;

--
-- Name: iptalrezervasyon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iptalrezervasyon (
    "rezervasyonNo" integer,
    "kullaniciNo" integer,
    zaman timestamp without time zone
);


ALTER TABLE public.iptalrezervasyon OWNER TO postgres;

--
-- Name: kiralananvArac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kiralananvArac" (
    "dosyaNo" integer NOT NULL,
    tutar integer NOT NULL,
    "aracNo" integer NOT NULL,
    "rezervasyonNo" integer NOT NULL,
    "sigortaKodu" character varying(3),
    "odemeNo" integer NOT NULL
);


ALTER TABLE public."kiralananvArac" OWNER TO postgres;

--
-- Name: kiralananvArac_dosyaNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."kiralananvArac_dosyaNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."kiralananvArac_dosyaNo_seq" OWNER TO postgres;

--
-- Name: kiralananvArac_dosyaNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."kiralananvArac_dosyaNo_seq" OWNED BY public."kiralananvArac"."dosyaNo";


--
-- Name: toplamsayilar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplamsayilar (
    aracsayisi integer NOT NULL,
    musterisayisi integer NOT NULL
);


ALTER TABLE public.toplamsayilar OWNER TO postgres;

--
-- Name: Kullanici kullaniciNo; Type: DEFAULT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Kullanici" ALTER COLUMN "kullaniciNo" SET DEFAULT nextval('"Kullanici"."Kullanici_kullaniciNo_seq"'::regclass);


--
-- Name: Odeme OdemeNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odeme" ALTER COLUMN "OdemeNo" SET DEFAULT nextval('public."Odeme_OdemeNo_seq"'::regclass);


--
-- Name: arac aracNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac ALTER COLUMN "aracNo" SET DEFAULT nextval('public."Arac_aracNo_seq"'::regclass);


--
-- Name: kiralananvArac dosyaNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac" ALTER COLUMN "dosyaNo" SET DEFAULT nextval('public."kiralananvArac_dosyaNo_seq"'::regclass);


--
-- Name: rezervasyon rezervasyonno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN rezervasyonno SET DEFAULT nextval('public."Rezervasyon_rezervasyonNo_seq"'::regclass);


--
-- Data for Name: Kullanici; Type: TABLE DATA; Schema: Kullanici; Owner: postgres
--

INSERT INTO "Kullanici"."Kullanici" VALUES
	(1, 'Buğra', 'Kayacan', '43300009055', 'kayacanbugra@gmail.com', '5433210359', 'b123', 'Personel'),
	(2, 'Eray', 'Gurel', '48680057159', 'eraygurel@hotmail.com', '5305987182', 'e123', 'Personel'),
	(3, 'Gizay', 'Gur', '46797979744', 'gizaygur@icloud.com', '5325475248', 'giz123', 'Musteri'),
	(4, 'Ata', 'Ulusoy', '48058747241', 'ataulusoy@gmail.com', '5742456874', 'ata123', 'Musteri'),
	(5, 'Ali', 'Kaya', '52872242874', 'alikaya98@hotmail.com', '5383595959', 'ali123', 'Musteri');


--
-- Data for Name: Musteri; Type: TABLE DATA; Schema: Kullanici; Owner: postgres
--

INSERT INTO "Kullanici"."Musteri" VALUES
	(3, 'M001'),
	(4, 'M002'),
	(5, 'M003');


--
-- Data for Name: Personel; Type: TABLE DATA; Schema: Kullanici; Owner: postgres
--



--
-- Data for Name: AracModeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."AracModeli" VALUES
	('RNCL-MV-D', 'RN', 'Clio', 95, 550, 'MV', 'DIZ'),
	('RNCL-OV-D', 'RN', 'Clio', 95, 650, 'OV', 'DIZ'),
	('RNMG-MV-B', 'RN', 'Megane', 115, 550, 'MV', 'BEN'),
	('RNMG-MV-D', 'RN', 'Megane', 105, 650, 'MV', 'DIZ'),
	('FTEG-MV-D', 'FT', 'Egea', 95, 600, 'MV', 'DIZ'),
	('OPAS-MV-B', 'OP', 'Astra', 140, 650, 'MV', 'BEN'),
	('OPIN-OV-D', 'OP', 'Insignia', 136, 950, 'OV', 'DIZ'),
	('OPCS-OV-B', 'OP', 'Corsa', 95, 650, 'OV', 'BEN'),
	('VWPS-MV-B', 'VW', 'Passat', 125, 900, 'MV', 'BEN'),
	('VWPS-OV-D', 'VW', 'Passat', 120, 1000, 'OV', 'DIZ'),
	('VWGF-OV-D', 'VW', 'Golf', 120, 800, 'OV', 'DIZ'),
	('AUA4-OV-D', 'AU', 'A4', 160, 1250, 'OV', 'DIZ');


--
-- Data for Name: Durum; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Durum" VALUES
	('B', 'Boşta'),
	('D', 'Dolu'),
	('A', 'Arızalı'),
	('S', 'Serviste');


--
-- Data for Name: Marka; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Marka" VALUES
	('VW', 'Volkswagen'),
	('RN', 'Renault'),
	('OP', 'Opel'),
	('FT', 'Fiat'),
	('AU', 'Audi');


--
-- Data for Name: Odeme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Odeme" VALUES
	(1, 400, '2022-12-24', 'CRD');


--
-- Data for Name: Odeme Yontem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Odeme Yontem" VALUES
	('CRD', 'Kredi Kartı'),
	('EFT', 'EFT/Havale'),
	('CSH', 'Nakit');


--
-- Data for Name: Renk; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Renk" VALUES
	('BYZ', 'Beyaz'),
	('SYH', 'Siyah'),
	('GRI', 'Gri'),
	('LCV', 'Lacivert'),
	('TRC', 'Turuncu'),
	('KRZ', 'Kırmızı'),
	('MVI', 'Mavi'),
	('GMS', 'Gümüş'),
	('KHV', 'Kahverengi');


--
-- Data for Name: Sigorta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Sigorta" VALUES
	('S00', 'Sigortasız', 0, ''),
	('S02', 'Mini Hasar', 400, 'Karşı tarafın hasarını ve araçtaki küçük hasarları karşılayan sigorta poliçesi'),
	('S03', 'Full Koruma', 700, 'Tüm hasarları karşılayan sigorta poliçesi'),
	('S01', 'Karşı Taraf', 200, 'Yalnızca karşı tarafın hasarını karşılayan sigorta poliçesi');


--
-- Data for Name: Vites; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Vites" VALUES
	('OV', 'Otomatik Vites'),
	('MV', 'Manuel Vites');


--
-- Data for Name: Yakit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Yakit" VALUES
	('DIZ', 'Dizel'),
	('BEN', 'Benzin');


--
-- Data for Name: arac; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.arac VALUES
	(1, '59FR500', 1500, 'BYZ', 'B', 'RNCL-MV-D'),
	(2, '59PP500', 2000, 'SYH', 'B', 'FTEG-MV-D'),
	(3, '59FK601', 8700, 'KRZ', 'B', 'OPCS-OV-B'),
	(4, '59FR777', 2500, 'GMS', 'B', 'RNMG-MV-D'),
	(6, '59YH500', 11200, 'BYZ', 'B', 'OPIN-OV-D'),
	(7, '59ABK300', 900, 'SYH', 'B', 'AUA4-OV-D'),
	(8, '34CMK990', 15300, 'BYZ', 'S', 'VWPS-MV-B'),
	(9, '59ZZ800', 9000, 'KRZ', 'B', 'OPAS-MV-B'),
	(10, '59PP430', 7800, 'GRI', 'B', 'VWGF-OV-D'),
	(11, '59B602', 9600, 'BYZ', 'B', 'VWPS-OV-D'),
	(12, '59LZ159', 19600, 'LCV', 'B', 'VWPS-MV-B');


--
-- Data for Name: iptalrezervasyon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.iptalrezervasyon VALUES
	(7, 4, '2022-12-27 03:28:47.453964');


--
-- Data for Name: kiralananvArac; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: rezervasyon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rezervasyon VALUES
	(6, '2022-12-26', '2022-12-27', 3),
	(8, '2022-12-28', '2022-12-29', 4);


--
-- Data for Name: toplamsayilar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.toplamsayilar VALUES
	(12, 3);


--
-- Name: Kullanici_kullaniciNo_seq; Type: SEQUENCE SET; Schema: Kullanici; Owner: postgres
--

SELECT pg_catalog.setval('"Kullanici"."Kullanici_kullaniciNo_seq"', 5, true);


--
-- Name: musteriSayac; Type: SEQUENCE SET; Schema: Kullanici; Owner: postgres
--

SELECT pg_catalog.setval('"Kullanici"."musteriSayac"', 1, false);


--
-- Name: Arac_aracNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Arac_aracNo_seq"', 12, true);


--
-- Name: Odeme_OdemeNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Odeme_OdemeNo_seq"', 1, true);


--
-- Name: Rezervasyon_rezervasyonNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rezervasyon_rezervasyonNo_seq"', 9, true);


--
-- Name: kiralananvArac_dosyaNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."kiralananvArac_dosyaNo_seq"', 2, true);


--
-- Name: musterisayaci; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.musterisayaci', 3, true);


--
-- Name: Kullanici kullaniciPK; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Kullanici"
    ADD CONSTRAINT "kullaniciPK" PRIMARY KEY ("kullaniciNo");


--
-- Name: Musteri musteriPK; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Musteri"
    ADD CONSTRAINT "musteriPK" PRIMARY KEY ("kullaniciNo");


--
-- Name: Personel personelPK; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Personel"
    ADD CONSTRAINT "personelPK" PRIMARY KEY ("kullaniciNo");


--
-- Name: Kullanici unique_Kullanici_TCkimlikNo; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Kullanici"
    ADD CONSTRAINT "unique_Kullanici_TCkimlikNo" UNIQUE ("TCkimlikNo");


--
-- Name: Kullanici unique_Kullanici_epostaAdresi; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Kullanici"
    ADD CONSTRAINT "unique_Kullanici_epostaAdresi" UNIQUE ("epostaAdresi");


--
-- Name: Kullanici unique_Kullanici_telNo; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Kullanici"
    ADD CONSTRAINT "unique_Kullanici_telNo" UNIQUE ("telNo");


--
-- Name: Musteri unique_Musteri_musteriNo; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Musteri"
    ADD CONSTRAINT "unique_Musteri_musteriNo" UNIQUE ("musteriNo");


--
-- Name: Personel unique_Personel_personelNo; Type: CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Personel"
    ADD CONSTRAINT "unique_Personel_personelNo" UNIQUE ("personelNo");


--
-- Name: Odeme Yontem Odeme Yontem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odeme Yontem"
    ADD CONSTRAINT "Odeme Yontem_pkey" PRIMARY KEY ("odemeYontemNo");


--
-- Name: Odeme OdemePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odeme"
    ADD CONSTRAINT "OdemePK" PRIMARY KEY ("OdemeNo");


--
-- Name: Renk RenkPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Renk"
    ADD CONSTRAINT "RenkPK" PRIMARY KEY ("renkKodu");


--
-- Name: arac aracPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT "aracPK" PRIMARY KEY ("aracNo");


--
-- Name: Durum durumPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Durum"
    ADD CONSTRAINT "durumPK" PRIMARY KEY ("durumKodu");


--
-- Name: kiralananvArac kiralananaracPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac"
    ADD CONSTRAINT "kiralananaracPK" PRIMARY KEY ("dosyaNo");


--
-- Name: Marka markaPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Marka"
    ADD CONSTRAINT "markaPK" PRIMARY KEY ("markaKodu");


--
-- Name: AracModeli modelPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModeli"
    ADD CONSTRAINT "modelPK" PRIMARY KEY ("modelKodu");


--
-- Name: rezervasyon rezervasyonPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT "rezervasyonPK" PRIMARY KEY (rezervasyonno);


--
-- Name: Sigorta sigortaPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sigorta"
    ADD CONSTRAINT "sigortaPK" PRIMARY KEY ("sigortaKodu");


--
-- Name: arac unique_Arac_plaka; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT "unique_Arac_plaka" UNIQUE (plaka);


--
-- Name: Marka unique_Marka_ad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Marka"
    ADD CONSTRAINT "unique_Marka_ad" UNIQUE (ad);


--
-- Name: Renk unique_Renk_renk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Renk"
    ADD CONSTRAINT "unique_Renk_renk" UNIQUE (renk);


--
-- Name: Sigorta unique_Sigorta_ad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sigorta"
    ADD CONSTRAINT "unique_Sigorta_ad" UNIQUE (ad);


--
-- Name: Vites unique_Vites_vites; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vites"
    ADD CONSTRAINT "unique_Vites_vites" UNIQUE (vites);


--
-- Name: Yakit unique_Yakit_yakit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yakit"
    ADD CONSTRAINT "unique_Yakit_yakit" UNIQUE (yakit);


--
-- Name: Durum unique_durum_ad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Durum"
    ADD CONSTRAINT unique_durum_ad UNIQUE (ad);


--
-- Name: kiralananvArac unique_kiralananvArac_aracNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac"
    ADD CONSTRAINT "unique_kiralananvArac_aracNo" UNIQUE ("aracNo");


--
-- Name: Vites vitesPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vites"
    ADD CONSTRAINT "vitesPK" PRIMARY KEY ("vitesKodu");


--
-- Name: Yakit yakitPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yakit"
    ADD CONSTRAINT "yakitPK" PRIMARY KEY ("yakitKodu");


--
-- Name: Musteri trigermusterisayisi; Type: TRIGGER; Schema: Kullanici; Owner: postgres
--

CREATE TRIGGER trigermusterisayisi AFTER INSERT ON "Kullanici"."Musteri" FOR EACH ROW EXECUTE FUNCTION public.musteriarttir();


--
-- Name: rezervasyon iptalrandevutriger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER iptalrandevutriger AFTER DELETE ON public.rezervasyon FOR EACH ROW EXECUTE FUNCTION public.iptalrezervasyonfunction();


--
-- Name: arac plakaKontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "plakaKontrol" BEFORE INSERT OR UPDATE ON public.arac FOR EACH ROW EXECUTE FUNCTION public."plakaEkle"();


--
-- Name: arac trigeraracsayisi; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigeraracsayisi AFTER INSERT ON public.arac FOR EACH ROW EXECUTE FUNCTION public.aracarttir();


--
-- Name: Musteri MusteriKullanici; Type: FK CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Musteri"
    ADD CONSTRAINT "MusteriKullanici" FOREIGN KEY ("kullaniciNo") REFERENCES "Kullanici"."Kullanici"("kullaniciNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Personel PersonelKullanici; Type: FK CONSTRAINT; Schema: Kullanici; Owner: postgres
--

ALTER TABLE ONLY "Kullanici"."Personel"
    ADD CONSTRAINT "PersonelKullanici" FOREIGN KEY ("kullaniciNo") REFERENCES "Kullanici"."Kullanici"("kullaniciNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: arac FK_Arac.durumKod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT "FK_Arac.durumKod" FOREIGN KEY ("durumKod") REFERENCES public."Durum"("durumKodu");


--
-- Name: arac FK_Arac.modelKodu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT "FK_Arac.modelKodu" FOREIGN KEY ("modelKodu") REFERENCES public."AracModeli"("modelKodu");


--
-- Name: arac FK_Arac.renk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT "FK_Arac.renk" FOREIGN KEY (renk) REFERENCES public."Renk"("renkKodu");


--
-- Name: AracModeli FK_AracModeli.markaKodu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModeli"
    ADD CONSTRAINT "FK_AracModeli.markaKodu" FOREIGN KEY (marka) REFERENCES public."Marka"("markaKodu");


--
-- Name: AracModeli FK_AracModeli.vitesKodu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModeli"
    ADD CONSTRAINT "FK_AracModeli.vitesKodu" FOREIGN KEY (vites) REFERENCES public."Vites"("vitesKodu");


--
-- Name: AracModeli FK_AracModeli.yakitKodu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracModeli"
    ADD CONSTRAINT "FK_AracModeli.yakitKodu" FOREIGN KEY (yakit) REFERENCES public."Yakit"("yakitKodu");


--
-- Name: Odeme FK_Odeme.odemeyontemNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Odeme"
    ADD CONSTRAINT "FK_Odeme.odemeyontemNo" FOREIGN KEY ("odemeyontemNo") REFERENCES public."Odeme Yontem"("odemeYontemNo");


--
-- Name: kiralananvArac FK_kiralananvArac.aracNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac"
    ADD CONSTRAINT "FK_kiralananvArac.aracNo" FOREIGN KEY ("aracNo") REFERENCES public.arac("aracNo");


--
-- Name: kiralananvArac FK_kiralananvArac.rezervasyonNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac"
    ADD CONSTRAINT "FK_kiralananvArac.rezervasyonNo" FOREIGN KEY ("rezervasyonNo") REFERENCES public.rezervasyon(rezervasyonno);


--
-- Name: kiralananvArac FK_kiralananvArac.sigortaKodu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kiralananvArac"
    ADD CONSTRAINT "FK_kiralananvArac.sigortaKodu" FOREIGN KEY ("sigortaKodu") REFERENCES public."Sigorta"("sigortaKodu");


--
-- Name: iptalrezervasyon iptalrezerveFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iptalrezervasyon
    ADD CONSTRAINT "iptalrezerveFK1" FOREIGN KEY ("kullaniciNo") REFERENCES "Kullanici"."Kullanici"("kullaniciNo");


--
-- Name: rezervasyon rezervasyonFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT "rezervasyonFK1" FOREIGN KEY (kullanicino) REFERENCES "Kullanici"."Musteri"("kullaniciNo");


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

