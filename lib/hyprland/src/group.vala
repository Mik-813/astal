namespace AstalHyprland {
public class Group : Object {
    public signal void destroyed();
    public signal void moved_to(Workspace workspace);

    public weak Client primary_client { get; private set; }
    private List<weak Client> _clients = new List<weak Client> ();
    public List<weak Client> clients { owned get { return _clients.copy(); } }

    public string address { get; private set; }
    public bool mapped { get; private set; }
    public bool hidden { get; private set; }
    public int x { get; private set; }
    public int y { get; private set; }
    public int width { get; private set; }
    public int height { get; private set; }
    public bool floating { get; private set; }
    public bool pinned { get; private set; }
    public Workspace workspace { get; private set; }
    public Monitor monitor { get; private set; }

    private void setClientsFromAdresses(List<string> addresses) {
        var hyprland = Hyprland.get_default();

        _clients = new List<weak Client>();
        foreach (var addr in addresses) {
            var client = hyprland?.get_client(addr);
            if (client != null)
                _clients.prepend((owned)client);
        }
        _clients.reverse();
        notify_property("clients");
    }

    internal void sync(GLib.List<string> addresses) {
        var hyprland = Hyprland.get_default();

        address = hyprland.pick_primary_address(addresses);

        setClientsFromAdresses(addresses);
        
        primary_client = hyprland.get_client(address);
        
        mapped = primary_client.mapped;
        hidden = primary_client.hidden;
        floating = primary_client.floating;
        pinned = primary_client.pinned;
        x = primary_client.x;
        y = primary_client.y;
        width = primary_client.width;
        height = primary_client.height;
        workspace = primary_client.workspace;
        monitor = primary_client.monitor;
    }

    public void focus() {
        primary_client.focus();
    }

    public void toggle_floating() {
        primary_client.toggle_floating();
    }
}
}