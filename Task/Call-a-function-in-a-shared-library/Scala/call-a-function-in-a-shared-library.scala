import net.java.dev.sna.SNA
import com.sun.jna.ptr.IntByReference

object GetDiskFreeSpace extends App with SNA {

  snaLibrary = "Kernel32" // Native library name
/*
 * Important Note!
 *
 * The val holding the SNA-returned function must have the same name as the native function itself
 * (see line following this comment). This is the only place you specify the native function name.
 */
  val GetDiskFreeSpaceA = SNA[String, IntByReference, IntByReference, IntByReference, IntByReference, Boolean]

  // This Windows function is described here:
  //     http://msdn.microsoft.com/en-us/library/aa364935(v=vs.85).aspx
  val (disk, spc, bps, fc, tc) = ("C:\\",
    new IntByReference, // Sectors per cluster
    new IntByReference, // Bytes per sector
    new IntByReference, // Free clusters
    new IntByReference) // Total clusters

  val ok = GetDiskFreeSpaceA(disk, spc, bps, fc, tc) // status
  println(f"'$disk%s' ($ok%s): sectors/cluster: ${spc.getValue}%d,  bytes/sector: ${bps.getValue}%d, " +
    f" free-clusters: ${fc.getValue}%d,  total/clusters: ${tc.getValue}%d%n")
}}
