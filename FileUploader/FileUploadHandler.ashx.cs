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
    public  class FileUploadHandler : HttpTaskAsyncHandler
    {
        Details data = new Details();
        public override async Task ProcessRequestAsync(HttpContext context)
        {
            string _name = "";
            if (context.Request.Files.Count > 0)
            {
                _Default obj = new _Default();
                string sp = obj.getPath();


                string path = System.Web.HttpContext.Current.Server.MapPath(sp);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                var size = obj.getSize();        // Size in kb
                var extensions = obj.getExtension();
                string[] e = extensions.Split(',');
                
                foreach (string file in System.Web.HttpContext.Current.Request.Files)
                {
                    var pic = System.Web.HttpContext.Current.Request.Files[file];
                    var fileName = Path.GetFileName(pic.FileName);
                    var _ext = Path.GetExtension(pic.FileName).ToLower();
                    var sizeinKB = Convert.ToDecimal(pic.ContentLength) / 1024;
                    if(extensions.IndexOf(_ext)==-1 || (sizeinKB > size))
                    {
                        data.isSuccess = false;
                        data.hasWarnings = true;
                        if (extensions.IndexOf(_ext) == -1)
                        {
                            data.warnings = "Please select only "+ extensions + " files.";
                            context.Response.Write(JsonConvert.SerializeObject(data));
                        }
                        else
                        {
                            data.warnings = "Files size must be less than " + size + " Kb.";
                            context.Response.Write(JsonConvert.SerializeObject(data));
                        }
                        
                    }
                    else
                    {
                        _name = fileName;
                        string _nameWithoutExt = Path.GetFileNameWithoutExtension(fileName);
                        var comPath = System.Web.HttpContext.Current.Server.MapPath("/" + sp + "/");
                        pic.SaveAs(comPath + _name);
                        var imgExt = obj._imgExtensions;
                        List<_Files> list = new List<_Files>();
                        if (imgExt.IndexOf(_ext) != -1)
                        {
                            if (!File.Exists(comPath + _nameWithoutExt + ".pdf"))
                            {
                                Document doc = new Document(PageSize.A4, 5, 5, 5, 5);
                                PdfWriter.GetInstance(doc, new FileStream(comPath + _nameWithoutExt + ".pdf", FileMode.Create));
                                doc.SetPageSize(iTextSharp.text.PageSize.A4.Rotate());
                                doc.Open();

                                iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(comPath + _name);
                                img.ScaleToFit(doc.PageSize);
                                img.SetAbsolutePosition(0, 0);
                                doc.Add(img);
                                doc.Close();
                                
                            }
                            //System.IO.File.Delete(comPath + _name);
                            FileInfo info = new FileInfo(comPath + _nameWithoutExt + ".pdf");


                            using (var client = new HttpClient())
                            {
                                client.BaseAddress = new Uri("http://localhost:9832/");
                                client.DefaultRequestHeaders.Accept.Clear();
                                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                                string filepath = info.FullName;
                                string filename = info.Name;

                                MultipartFormDataContent content = new MultipartFormDataContent();
                                ByteArrayContent fileContent = new ByteArrayContent(System.IO.File.ReadAllBytes(filepath));
                                fileContent.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = filename };
                                content.Add(fileContent);

                                HttpResponseMessage response = await client.PostAsync("analyse", content);
                                string returnString = await response.Content.ReadAsStringAsync();

                                data.isSuccess = true;
                                data.hasWarnings = false;

                                list.Add(new _Files
                                {
                                    name = _name
                                });
                                data.files = list;
                                data.result = returnString;

                                context.Response.Write(JsonConvert.SerializeObject(data));
                            }
                        }
                        else
                        {
                            
                            using (var client = new HttpClient())
                            {
                                client.BaseAddress = new Uri("http://localhost:9832/");
                                client.DefaultRequestHeaders.Accept.Clear();
                                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                                string filepath = comPath + _name;
                                string filename = _name;

                                MultipartFormDataContent content = new MultipartFormDataContent();
                                ByteArrayContent fileContent = new ByteArrayContent(System.IO.File.ReadAllBytes(filepath));
                                fileContent.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = filename };
                                content.Add(fileContent);

                                HttpResponseMessage response = await client.PostAsync("analyse", content);
                                string returnString = await response.Content.ReadAsStringAsync();

                                data.isSuccess = true;
                                data.hasWarnings = false;

                                list.Add(new _Files
                                {
                                    name = _name
                                });
                                data.files = list;
                                data.result = returnString;

                                context.Response.Write(JsonConvert.SerializeObject(data));
                            }
                        }

                        //data.isSuccess = true;
                        //    data.hasWarnings = false;

                        //list.Add(new _Files
                        //{
                        //    name = _name
                        //});
                        //data.files = list;
                       
                    }


                    //----------------------------Original Code-----------------------
                    //else
                    //{
                    //    //_name = Guid.NewGuid().ToString() + fileName;
                    //    _name = fileName;
                    //    var comPath = System.Web.HttpContext.Current.Server.MapPath("/" + sp + "/") + _name;
                    //    pic.SaveAs(comPath);
                    //    data.isSuccess = true;
                    //    data.hasWarnings = false;
                    //    List<_Files> list = new List<_Files>();
                    //    list.Add(new _Files {
                    //        name=_name
                    //    });
                    //    data.files = list;
                    //}
                    //---------------------------------------------------------------------
                }
            }

            //context.Response.Write(JsonConvert.SerializeObject(data));
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