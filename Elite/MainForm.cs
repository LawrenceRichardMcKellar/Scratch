namespace Elite
{
    public partial class MainForm : Form
    {

        public MainForm()
        {
            InitializeComponent();

            var sheet = new Sheet(new SheetCell[100, 100], "Sample");

            var random = new Random();
            for (uint row = 0; row < sheet.Rows; row++)
            {
                for (uint column = 0; column < sheet.Columns; column++)
                {
                    sheet[row, column].Value = random.Next();
                }
            }

            sheet[0, 0].Value = 1000;
            sheet[1, 0].Value = 1000.00;
            sheet[0, 1].Value = true;
            sheet[1, 1].Value = "hello";

            MainCanvas.Add(sheet);
        }
    }
}