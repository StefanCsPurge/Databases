using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


/*<!--
	<appSettings>
		<add key="Parent" value="Teams"/>
		<add key="ParentColumnNames" value="Tid,Designation,NoOfMembers,LeaderName"/>
		<add key="ParentId" value="Tid"/>
		<add key="SelectAllFromParent" value="SELECT * FROM Teams"/>

		<add key="Child" value="Employees"/>
		<add key="ChildColumnNames" value="Eid,Name,Surname,Age,Tid"/>
		<add key="ChildColumnNamesForUpdate" value="Name,Surname,Age,Tid"/>
		<add key="ChildColumnNamesForInsert" value="Eid,Name,Surname,Age,Tid"/>
		<add key="ChildId" value="Eid"/>

		<add key="SelectOneFromChild" value="SELECT * FROM Employees E WHERE E.Tid=@Tid"/>
		<add key="InsertChild" value="INSERT INTO Employees(Eid,Name,Surname,Age,Tid) VALUES (@Eid, @Name, @Surname, @Age, @Tid)"/>
		<add key="DeleteChild" value="DELETE FROM Employees WHERE Eid=@Eid"/>
		<add key="UpdateChild" value="UPDATE Employees SET Name=@Name, Surname=@Surname, Age=@Age, Tid=@Tid WHERE Eid=@Eid"/>

	</appSettings>
	-->

	
	<appSettings>
		<add key="Parent" value="MalwareAuthors"/>
		<add key="ParentColumnNames" value="Aid,Name,Surname,Location"/>
		<add key="ParentId" value="Aid"/>
		<add key="SelectAllFromParent" value="SELECT * FROM MalwareAuthors"/>

		<add key="Child" value="Malware"/>
		<add key="ChildColumnNames" value="Mid,Name,Type,Aid,Severity,MainExploitedVuln"/>
		<add key="ChildColumnNamesForUpdate" value="Name,Type,Aid,Severity,MainExploitedVuln"/>
		<add key="ChildColumnNamesForInsert" value="Name,Type,Aid,Severity,MainExploitedVuln"/>
		<add key="ChildId" value="Mid"/>

		<add key="SelectOneFromChild" value="SELECT * FROM Malware M WHERE M.Aid=@Aid"/>
		<add key="InsertChild" value="INSERT INTO Malware(Name,Type,Aid,Severity,MainExploitedVuln) VALUES (@Name,@Type,@Aid,@Severity,@MainExploitedVuln)"/>
		<add key="DeleteChild" value="DELETE FROM Malware WHERE Mid=@Mid"/>
		<add key="UpdateChild" value="UPDATE Malware SET Name=@Name, Type=@Type, Aid=@Aid, Severity=@Severity, MainExploitedVuln=@MainExploitedVuln WHERE Mid=@Mid"/>

	</appSettings>
*/

namespace TeamsEmployeesDBManager
{
    public partial class Form1 : Form
    { SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["cn"].ConnectionString);
        SqlDataAdapter ParentAdapter, ChildAdapter;
        DataSet ds;
        public Form1()
        {
            InitializeComponent();
        }

        private void addControls(Panel panel, List<string> columnNames)
        {
            int y = 10;
            foreach (string column in columnNames)
            {
                TextBox newTextBox = new TextBox();
                newTextBox.Name = column;

                Label newLabel = new Label();
                newLabel.Text = column;
                newLabel.AutoSize = true;

                newLabel.Location = new Point(0, y);
                newTextBox.Location = new Point(8 + newLabel.Size.Width, y);
                y += newLabel.Size.Height;

                panel.Controls.Add(newLabel);
                panel.Controls.Add(newTextBox);
            }
        }

        private void addChild()
        {
            ds = new DataSet();
            ChildAdapter.InsertCommand = new SqlCommand(ConfigurationManager.AppSettings["InsertChild"], connection);
            List<string> columns = new List<string>(ConfigurationManager.AppSettings["ChildColumnNamesForInsert"].Split(','));
            foreach (string column in columns)
                ChildAdapter.InsertCommand.Parameters.AddWithValue("@" + column, panel2.Controls[column].Text);
            connection.Open();
            try
            {
                ChildAdapter.InsertCommand.ExecuteNonQuery();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message, "Error !", MessageBoxButtons.OK, MessageBoxIcon.Error);
                connection.Close();
                return;
            }
            ChildAdapter.Fill(ds, ConfigurationManager.AppSettings["Child"]);
            dataGridView2.DataSource = ds.Tables[0];
            connection.Close();
        }

        private void updateChild()
        {
            ds = new DataSet();
            ChildAdapter.UpdateCommand = new SqlCommand(ConfigurationManager.AppSettings["UpdateChild"], connection);
            List<string> columns = new List<string>(ConfigurationManager.AppSettings["ChildColumnNamesForUpdate"].Split(','));
            foreach (string column in columns)
                ChildAdapter.UpdateCommand.Parameters.AddWithValue("@" + column, panel2.Controls[column].Text);
            ChildAdapter.UpdateCommand.Parameters.AddWithValue("@" + ConfigurationManager.AppSettings["ChildId"], panel2.Controls[ConfigurationManager.AppSettings["ChildId"]].Text);
            //ChildAdapter.UpdateCommand.Parameters.AddWithValue("@" + ConfigurationManager.AppSettings["ParentId"], panel1.Controls[ConfigurationManager.AppSettings["ParentId"]].Text);

            connection.Open();
            DialogResult dialogResult = MessageBox.Show("Are you sure you want to update the" + ConfigurationManager.AppSettings["Child"] + " entity with id:" +
                panel2.Controls[ConfigurationManager.AppSettings["ChildId"]].Text,
               "Attention !", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (dialogResult == DialogResult.Yes)
                try
                {
                    ChildAdapter.UpdateCommand.ExecuteNonQuery();
                }
                catch (Exception error)
                {
                    MessageBox.Show(error.Message, "Error !", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    connection.Close();
                    return;
                }

            ChildAdapter.Fill(ds, ConfigurationManager.AppSettings["Child"]);
            dataGridView2.DataSource = ds.Tables[0];
            connection.Close();
        }

        private void deleteChild()
        {
            ds = new DataSet();
            ChildAdapter.DeleteCommand = new SqlCommand(ConfigurationManager.AppSettings["DeleteChild"], connection);
            ChildAdapter.DeleteCommand.Parameters.AddWithValue("@" + ConfigurationManager.AppSettings["ChildId"], panel2.Controls[ConfigurationManager.AppSettings["ChildId"]].Text);

            connection.Open();

            DialogResult dialogResult = MessageBox.Show("Are you sure you want to delete the " + ConfigurationManager.AppSettings["Child"] + " entity with id:" +
                panel2.Controls[ConfigurationManager.AppSettings["ChildId"]].Text,
               "Attention !", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (dialogResult == DialogResult.Yes)
                try
                {
                    ChildAdapter.DeleteCommand.ExecuteNonQuery();
                }
                catch (Exception error)
                {
                    MessageBox.Show(error.Message, "Error !", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    connection.Close();
                    return;
                }

            ChildAdapter.Fill(ds, ConfigurationManager.AppSettings["Child"]);
            dataGridView2.DataSource = ds.Tables[0];
            connection.Close();
        }

        private void addButtonsForChild()
        {
            Button addButton = new Button();
            {
                addButton.Text = "Add";
                addButton.Name = "AddChild";
                addButton.Click += (s, e) => { addChild(); };
                addButton.Height = 30;
                addButton.Width = 100;
                addButton.Location = new Point(0, panel2.Height - addButton.Height - 20);
            }
            panel2.Controls.Add(addButton);

            Button updateButton = new Button();
            {
                updateButton.Text = "Update";
                updateButton.Name = "UpdateChild";
                updateButton.Click += (s, e) => { updateChild(); };
                updateButton.Height = 30;
                updateButton.Width = 100;
                updateButton.Location = new Point(addButton.Width + 10, panel2.Height - updateButton.Height - 20);
            }
            panel2.Controls.Add(updateButton);

            Button deleteButton = new Button();
            {
                deleteButton.Text = "Delete";
                deleteButton.Name = "DeleteChild";
                deleteButton.Click += (s, e) => { deleteChild(); };
                deleteButton.Height = 30;
                deleteButton.Width = 100;
                deleteButton.Location = new Point(addButton.Width + 10 + updateButton.Width + 10, panel2.Height - deleteButton.Height - 20);
            }
            panel2.Controls.Add(deleteButton);
        }

        private void connectTBoxGrids(Panel panel, List<String> columnList, DataGridView dataGridView)
        {
            int index = 0;
            foreach (string column in columnList)
            {
                if (dataGridView.SelectedRows.Count == 0)
                {
                    if (dataGridView.CurrentRow != null)
                    {
                        panel.Controls[column].DataBindings.Clear();
                        panel.Controls[column].DataBindings.Add(new Binding("Text", dataGridView.CurrentRow.Cells[index], "Value"));
                    }
                }
                else
                {
                    panel.Controls[column].DataBindings.Clear();
                    panel.Controls[column].DataBindings.Add(new Binding("Text", dataGridView.SelectedRows[0].Cells[index], "Value"));
                }
                index++;
            }
        }

        private void dataGridView1_SelectionChanged(object sender, EventArgs e)
        {
            connectTBoxGrids(panel1, new List<string>(ConfigurationManager.AppSettings["ParentColumnNames"].Split(',')), dataGridView1);

            ds = new DataSet();
            SqlCommand command = new SqlCommand(ConfigurationManager.AppSettings["SelectOneFromChild"], connection);
            command.Parameters.AddWithValue("@" + ConfigurationManager.AppSettings["ParentId"], ((TextBox)panel1.Controls[ConfigurationManager.AppSettings["ParentId"]]).Text);
            ChildAdapter = new SqlDataAdapter(command);
            ChildAdapter.Fill(ds, ConfigurationManager.AppSettings["Child"]);

            dataGridView2.DataSource = ds.Tables[0];
            connectTBoxGrids(panel2, new List<string>(ConfigurationManager.AppSettings["ChildColumnNames"].Split(',')), dataGridView2);
        }

        private void dataGridView2_SelectionChanged(object sender, EventArgs e)
        {
            connectTBoxGrids(panel2, new List<string>(ConfigurationManager.AppSettings["ChildColumnNames"].Split(',')), dataGridView2);
        }


        private void Form1_Load(object sender, EventArgs e)
        {
            addControls(panel1, new List<string>(ConfigurationManager.AppSettings["ParentColumnNames"].Split(',')));
            addControls(panel2, new List<string>(ConfigurationManager.AppSettings["ChildColumnNames"].Split(',')));
            addButtonsForChild();
            ds = new DataSet();
            ParentAdapter = new SqlDataAdapter(ConfigurationManager.AppSettings["SelectAllFromParent"], connection);
            ParentAdapter.Fill(ds, ConfigurationManager.AppSettings["Parent"]);

            dataGridView1.DataSource = ds.Tables[0];
            connectTBoxGrids(panel1, new List<string>(ConfigurationManager.AppSettings["ParentColumnNames"].Split(',')), dataGridView1);
        }
    }
}
