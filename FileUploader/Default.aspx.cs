using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FileUploader
{
    public partial class _Default : Page
    {
        public string _pathname = "uploads"; // Directory name to upload the content.
        public string _setExtensions = ".jpeg,.jpg,.png,.bmp,.gif,.txt,.docx,.xlsx.,.pptx,.pdf,.tiff";// All the extensions are separated by comma.
        public int _setSize = 7168; // Size in KB

        public string _imgExtensions = ".jpeg,.jpg,.png,.bmp,.gif";
        public string _pdfPath = "pdfUploads";  // Convert image file into pdf.
        protected void Page_Load(object sender, EventArgs e)
        {
            setExtensions_.Text = Convert.ToString(_setExtensions);
            setSize_.Text = Convert.ToString(_setSize);
        }

        public string getPath()
        {
            return _pathname;
        }

        public string getExtension()
        {
            return _setExtensions;
        }

        public int getSize()
        {
            return _setSize;
        }
    }
}