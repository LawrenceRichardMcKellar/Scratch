namespace Elite
{
    partial class MainForm
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            MainMenuStrip = new MenuStrip();
            MainStatusStrip = new StatusStrip();
            CellTypeDropDownList = new ComboBox();
            CellTextBox = new TextBox();
            MainCanvas = new Canvas();
            SuspendLayout();
            // 
            // MainMenuStrip
            // 
            MainMenuStrip.Location = new Point(0, 0);
            MainMenuStrip.Name = "MainMenuStrip";
            MainMenuStrip.Size = new Size(1262, 24);
            MainMenuStrip.TabIndex = 0;
            MainMenuStrip.Text = "menuStrip1";
            // 
            // MainStatusStrip
            // 
            MainStatusStrip.Location = new Point(0, 708);
            MainStatusStrip.Name = "MainStatusStrip";
            MainStatusStrip.Size = new Size(1262, 22);
            MainStatusStrip.TabIndex = 1;
            MainStatusStrip.Text = "statusStrip1";
            // 
            // CellTypeDropDownList
            // 
            CellTypeDropDownList.FormattingEnabled = true;
            CellTypeDropDownList.Items.AddRange(new object[] { "", "text", "boolean", "number", "date", "time", "date/time" });
            CellTypeDropDownList.Location = new Point(12, 27);
            CellTypeDropDownList.Name = "CellTypeDropDownList";
            CellTypeDropDownList.Size = new Size(121, 23);
            CellTypeDropDownList.TabIndex = 2;
            // 
            // CellTextBox
            // 
            CellTextBox.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            CellTextBox.Location = new Point(139, 27);
            CellTextBox.Name = "CellTextBox";
            CellTextBox.Size = new Size(1111, 23);
            CellTextBox.TabIndex = 3;
            // 
            // MainCanvas
            // 
            MainCanvas.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            MainCanvas.Location = new Point(12, 56);
            MainCanvas.Name = "MainCanvas";
            MainCanvas.Size = new Size(1238, 640);
            MainCanvas.TabIndex = 4;
            MainCanvas.Text = "canvas1";
            // 
            // MainForm
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1262, 730);
            Controls.Add(MainCanvas);
            Controls.Add(CellTextBox);
            Controls.Add(CellTypeDropDownList);
            Controls.Add(MainStatusStrip);
            Controls.Add(MainMenuStrip);
            MainMenuStrip = MainMenuStrip;
            Name = "MainForm";
            Text = "Main Form";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private MenuStrip MainMenuStrip;
        private StatusStrip MainStatusStrip;
        private ComboBox CellTypeDropDownList;
        private TextBox CellTextBox;
        private Canvas MainCanvas;
    }
}