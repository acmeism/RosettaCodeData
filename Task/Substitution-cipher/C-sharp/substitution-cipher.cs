using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SubstitutionCipherProject
{
    class SubstitutionCipher
    {
        static void Main(string[] args)
        {
            doEncDec("e:\\source.txt", "enc.txt", true);
            doEncDec("enc.txt", "dec.txt", false);
            Console.WriteLine("Done");
            Console.ReadKey();
        }
        static void doEncDec(String source, String target, bool IsEncrypt)
        {
            ITransform trans;

            if (IsEncrypt)
                trans = new Encrypt();
            else
                trans = new Decrypt();

            FileInfo sfi = new FileInfo(source);
            FileStream sstream = sfi.OpenRead();
            StreamReader sr = new StreamReader(sstream);

            FileInfo tfi = new FileInfo(target);
            FileStream tstream = tfi.OpenWrite();
            TransformWriter tw = new TransformWriter(tstream, trans);
            StreamWriter sw = new StreamWriter(tw);

            String line;
            while ((line = sr.ReadLine()) != null)
                sw.WriteLine(line);
            sw.Close();
        }
    }
    public interface ITransform
    {
        byte transform(byte ch);
    }
    public class Encrypt : ITransform
    {
        const String str = "xyfagchbimpourvnqsdewtkjzl";
        byte ITransform.transform(byte ch)
        {
            if (char.IsLower((char)ch))
                ch = (byte)str[ch - (byte)'a'];
            return ch;
        }
    }
    class Decrypt : ITransform
    {
        const String str = "xyfagchbimpourvnqsdewtkjzl";
        byte ITransform.transform(byte ch)
        {
            if (char.IsLower((char)ch))
                ch = (byte)(str.IndexOf((char)ch) + 'a');
            return ch;
        }
    }
    class TransformWriter : Stream, IDisposable
    {
        private Stream outs;
        private ITransform trans;

        public TransformWriter(Stream s, ITransform t)
        {
            this.outs = s;
            this.trans = t;
        }

        public override bool CanRead
        {
            get { return false; }
        }

        public override bool CanSeek
        {
            get { return false; }
        }

        public override bool CanWrite
        {
            get { return true; }
        }
        public override void Flush()
        {
            outs.Flush();
        }

        public override long Length
        {
            get { return outs.Length; }
        }
        public override long Position
        {
            get
            {
                return outs.Position;
            }
            set
            {
                outs.Position = value;
            }
        }
        public override long Seek(long offset, SeekOrigin origin)
        {
            return outs.Seek(offset, origin);
        }

        public override void SetLength(long value)
        {
            outs.SetLength(value);
        }

        public override void Write(byte[] buf, int off, int len)
        {
            for (int i = off; i < off + len; i++)
                buf[i] = trans.transform(buf[i]);
            outs.Write(buf, off, len);
        }

        void IDisposable.Dispose()
        {
            outs.Dispose();
        }

        public override void Close()
        {
            outs.Close();
        }

        public override int Read(byte[] cbuf, int off, int count)
        {
            return outs.Read(cbuf, off, count);
        }
    }
}
