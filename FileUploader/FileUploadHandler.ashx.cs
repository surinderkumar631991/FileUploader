using FileUploader.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace FileUploader
{
    /// <summary>
    /// Summary description for FileUploadHandler1
    /// </summary>
    public class FileUploadHandler : IHttpHandler
    {
        Details data = new Details();
        public void ProcessRequest(HttpContext context)
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
                //string[] e = extensions.Split(',');

                foreach (string file in System.Web.HttpContext.Current.Request.Files)
                {
                    var pic = System.Web.HttpContext.Current.Request.Files[file];
                    var fileName = Path.GetFileName(pic.FileName);
                    var _ext = Path.GetExtension(pic.FileName).ToLower();
                    var sizeinKB = Convert.ToDecimal(pic.ContentLength) / 1024;
                    if (extensions.IndexOf(_ext) == -1 || (sizeinKB > size))
                    {
                        data.isSuccess = false;
                        data.hasWarnings = true;
                        if (extensions.IndexOf(_ext) == -1)
                        {
                            data.warnings = "Please select only " + extensions + " files.";
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
                        var comPath = System.Web.HttpContext.Current.Server.MapPath("/" + sp + "/") + _name;
                        pic.SaveAs(comPath);
                        data.isSuccess = true;
                        data.hasWarnings = false;
                        List<_Files> list = new List<_Files>();
                        list.Add(new _Files
                        {
                            name = _name
                        });
                        data.files = list;
                        context.Response.Write(JsonConvert.SerializeObject(data));
                    }
                }
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