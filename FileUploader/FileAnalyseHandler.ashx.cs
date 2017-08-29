using FileUploader.Models;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;

namespace FileUploader
{
    /// <summary>
    /// Summary description for FileUploadHandler
    /// </summary>
    public  class FileAnalyseHandler : HttpTaskAsyncHandler
    {
        Details data = new Details();
        public override async Task ProcessRequestAsync(HttpContext context)
        {
            string filesName = context.Request["names"];
            _Default obj = new _Default();
            string sp = obj.getPath();
            string[] filesarray = filesName.Substring(0,filesName.Length-1).Split(',');

            string path = System.Web.HttpContext.Current.Server.MapPath(sp);
            var imgExt = obj._imgExtensions;
            MultipartFormDataContent content = new MultipartFormDataContent();                       

            for (int i = 0; i < filesarray.Length; i++)
            {
                var ext = filesarray[i].Substring(filesarray[i].IndexOf('.')).ToLower();
                var fName = filesarray[i].Substring(0,filesarray[i].IndexOf('.'));
                
                if (imgExt.IndexOf(ext) != -1)
                {
                    if (!File.Exists(path + "/" + fName + ".pdf"))
                    {
                        Document doc = new Document(PageSize.A4, 5, 5, 5, 5);
                        PdfWriter.GetInstance(doc, new FileStream(path + "/" + fName + ".pdf", FileMode.Create));

                        doc.SetPageSize(iTextSharp.text.PageSize.A4.Rotate());
                        doc.Open();

                        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(path + "/" + filesarray[i]);
                        img.ScaleToFit(doc.PageSize);
                        img.SetAbsolutePosition(0, 0);
                        doc.Add(img);
                        doc.Close();
                    }
                    FileInfo info = new FileInfo(path + "/" + fName + ".pdf");
                    ByteArrayContent fileContent = new ByteArrayContent(System.IO.File.ReadAllBytes(info.FullName));
                    fileContent.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = info.Name };
                    content.Add(fileContent);
                }
                else
                {
                    FileInfo info = new FileInfo(path + "/" + filesarray[i]);
                    ByteArrayContent fileContent = new ByteArrayContent(System.IO.File.ReadAllBytes(info.FullName));
                    fileContent.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = info.Name };
                    content.Add(fileContent);
                }
            }
            
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://localhost:9832/");
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
               
                HttpResponseMessage response = await client.PostAsync("analyse", content);
                string returnString = await response.Content.ReadAsStringAsync();

                context.Response.Write(returnString);
            }            

        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}