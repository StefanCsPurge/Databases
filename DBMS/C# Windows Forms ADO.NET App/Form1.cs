using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

/*
Create a C# Windows Forms application that uses ADO.NET to interact with the database you developed in the 1st semester. 
The application must contain a form allowing the user to manipulate data in 2 tables that are in a 
1:n relationship(parent table and child table). 

The application must provide the following functionalities:
– display all the records in the parent table;
– display the child records for a specific (i.e., selected) parent record;
– add / remove / update child records for a specific parent record.

You must use the DataSet and SqlDataAdapter classes. You are free to use any controls on the form.
*/

namespace TeamsEmployeesDBManager
{
    public partial class Form1 : Form
    {
        SqlConnection cs = new SqlConnection("Data Source=DESKTOP-JGLQD8P\\SQLEXPRESS;Initial Catalog=Cybersecurity_Company;Integrated Security=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();
        SqlDataAdapter da2 = new SqlDataAdapter();
        DataSet ds2 = new DataSet();

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM Teams", cs);
            ds.Clear();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            try
            {
                da2.InsertCommand = new SqlCommand("INSERT INTO Employees(Eid,Name,Surname,Age,Tid) VALUES (@i, @n, @s, @a, @t)", cs);

                da2.InsertCommand.Parameters.Add("@i", SqlDbType.Int).Value = Int32.Parse(textBox1.Text);
                da2.InsertCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = textBox2.Text;
                da2.InsertCommand.Parameters.Add("@s", SqlDbType.VarChar).Value = textBox3.Text;
                da2.InsertCommand.Parameters.Add("@a", SqlDbType.Int).Value = Int32.Parse(textBox4.Text);
                da2.InsertCommand.Parameters.Add("@t", SqlDbType.Int).Value = Int32.Parse(textBox5.Text);
                cs.Open();
                da2.InsertCommand.ExecuteNonQuery();
                MessageBox.Show("Added succesfully in the database");
                cs.Close();
                ds2.Clear();
                da2.Fill(ds2);
                dataGridView2.DataSource = ds2.Tables[0];
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }

        private void showEmployeesButton_Click(object sender, EventArgs e)
        {
            try
            {
                da2.SelectCommand = new SqlCommand("SELECT * FROM Employees E WHERE E.Tid=@t", cs);
                da2.SelectCommand.Parameters.Add("@t", SqlDbType.Int).Value = Int32.Parse(textBox5.Text);
                ds2.Clear();
                da2.Fill(ds2);
                dataGridView2.DataSource = ds2.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                da2.DeleteCommand = new SqlCommand("DELETE FROM Employees WHERE EID=@i", cs);
                da2.DeleteCommand.Parameters.Add("@i", SqlDbType.Int).Value = Int32.Parse(textBox1.Text);
                cs.Open();
                da2.DeleteCommand.ExecuteNonQuery();
                MessageBox.Show("Deleted succesfully from the database");
                cs.Close();
                ds2.Clear();
                da2.Fill(ds2);
                dataGridView2.DataSource = ds2.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                da2.UpdateCommand = new SqlCommand("UPDATE Employees SET Name=@n, Surname=@s, Age=@a WHERE Eid=@i AND Tid=@t", cs);

                da2.UpdateCommand.Parameters.Add("@i", SqlDbType.Int).Value = Int32.Parse(textBox1.Text);
                da2.UpdateCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = textBox2.Text;
                da2.UpdateCommand.Parameters.Add("@s", SqlDbType.VarChar).Value = textBox3.Text;
                da2.UpdateCommand.Parameters.Add("@a", SqlDbType.Int).Value = Int32.Parse(textBox4.Text);
                da2.UpdateCommand.Parameters.Add("@t", SqlDbType.Int).Value = Int32.Parse(textBox5.Text);
                cs.Open();
                da2.UpdateCommand.ExecuteNonQuery();
                MessageBox.Show("Update done");
                cs.Close();
                ds2.Clear();
                da2.Fill(ds2);
                dataGridView2.DataSource = ds2.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
