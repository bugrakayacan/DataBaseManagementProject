using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace vtarac
{
    public partial class AracRezerve : Form
    {
        public AracRezerve()
        {
            InitializeComponent();

        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server = localHost; port= 5432; Database=AracKiralamaUygulamasi; user ID= postgres; password = bugra*03");
        
        void liste()
        { 
        string sorgu = "select * from rezervasyon";
        NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
        DataSet ds = new DataSet();
        da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void btnlistele_Click(object sender, EventArgs e)
        {
            string sorgu = "select * from rezervasyon";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu,baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void btnekle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into rezervasyon (kullanicino,baslangictarihi,bitistarihi) values (@p1,@p2,@p3)", baglanti);
            komut1.Parameters.AddWithValue("@p1", int.Parse(textid.Text));
            komut1.Parameters.AddWithValue("@p2", dtbaslangic.Value.Date);
            komut1.Parameters.AddWithValue("@p3", dtbitis.Value.Date);
            komut1.ExecuteNonQuery();
            baglanti.Close();
            liste();
            MessageBox.Show("Rezervasyonunuz Başarılı Bir Şekilde Oluşturuldu","Bilgi", MessageBoxButtons.OK);
        }

        private void btnguncelle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut3 = new NpgsqlCommand("update rezervasyon set baslangictarihi=@p1,bitistarihi=@p2 where rezervasyonno=@p3", baglanti);
            komut3.Parameters.AddWithValue("@p1", dtbaslangic.Value.Date);
            komut3.Parameters.AddWithValue("@p2", dtbitis.Value.Date);
            komut3.Parameters.AddWithValue("@p3", int.Parse(textrezervasyon.Text));
            komut3.ExecuteNonQuery();
            baglanti.Close();
            liste();
            MessageBox.Show("Randevunuz Güncellendi","Bilgi", MessageBoxButtons.OK);
        }

        private void btnsil_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut2 = new NpgsqlCommand("Delete from rezervasyon where rezervasyonno = @p1", baglanti);
            komut2.Parameters.AddWithValue("@p1", int.Parse(textrezervasyon.Text));
            komut2.ExecuteNonQuery();
            baglanti.Close();
            liste();
            MessageBox.Show("Rezervasyonunuz Silindi","Bilgi",MessageBoxButtons.OK);
        }

        private void btnarama_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            int musteriid = int.Parse(textid.Text);
            string sql = "select * from rezervasyon where kullanicino = '" + musteriid + "'";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sql, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            baglanti.Close();
        }
    }
}
