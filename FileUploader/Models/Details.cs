using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FileUploader.Models
{
    public class Details
    {
        public bool hasWarnings { get; set; }

        public bool isSuccess { get; set; }

        public string warnings { get; set; }

        public List<_Files> files { get; set; }

        public string result { get; set; }

    }

    public class _Files
    {
        public string name { get; set; }
    }

   
}