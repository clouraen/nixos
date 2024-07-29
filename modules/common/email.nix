{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.personal.enable {
    home-manager.users.${config.user} = {
      programs = {
        aerc = {
          enable = true;
          extraConfig = ''
            [compose]
            edit-headers = true
            file-picker-cmd = fzf --multi --query=%s
            reply-to-self = false

            [filters]
            .headers = ${pkgs.aerc}/libexec/aerc/filters/colorize
            text/calendar = ${pkgs.gawk}/bin/awk -f ${pkgs.aerc}/libexec/aerc/filters/calendar
            text/html = ${pkgs.aerc}/libexec/aerc/filters/html | ${pkgs.aerc}/libexec/aerc/filters/colorize
            text/plain = ${pkgs.aerc}/libexec/aerc/filters/colorize
            text/* = ${pkgs.bat}/bin/bat -fP --file-name="$AERC_FILENAME "
            message/delivery-status = ${pkgs.aerc}/libexec/aerc/filters/colorize
            message/rfc822 = ${pkgs.aerc}/libexec/aerc/filters/colorize
            application/pdf = ${pkgs.zathura}/bin/zathura -
            application/x-sh = ${pkgs.bat}/bin/bat -fP -l sh
            audio/* = ${pkgs.mpv}/bin/mpv -

            [general]
            default-menu-cmd = ${pkgs.fzf}/bin/fzf
            enable-osc8 = true
            pgp-provider = gpg
            unsafe-accounts-conf = true

            [viewer]
            header-layout = From|To,Cc|Bcc,Date,Subject,DKIM+|SPF+|DMARC+

            [ui]
            tab-title-account = {{.Account}} {{if .Unread}}({{.Unread}}){{end}}
            fuzzy-complete = true
            mouse-enabled = true
            msglist-scroll-offset = 5
            show-thread-context = true
            thread-prefix-dummy = ┬
            thread-prefix-first-child = ┬
            thread-prefix-folded = +
            thread-prefix-has-siblings = ├
            thread-prefix-indent = 
            thread-prefix-last-sibling = ╰
            thread-prefix-limb = ─
            thread-prefix-lone =  
            thread-prefix-orphan = ┌
            thread-prefix-stem = │
            thread-prefix-tip = 
            thread-prefix-unfolded = 
            threading-enabled = true
          '';

          extraBinds = ''
            # Binds are of the form <key sequence> = <command to run>
            # To use '=' in a key sequence, substitute it with "Eq": "<Ctrl+Eq>"
            # If you wish to bind #, you can wrap the key sequence in quotes: "#" = quit
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>
            \[t = :prev-tab<Enter>
            \]t = :next-tab<Enter>
            <C-t> = :term<Enter>
            ? = :help keys<Enter>
            <C-c> = :prompt 'Quit?' quit<Enter>
            <C-q> = :prompt 'Quit?' quit<Enter>
            <C-z> = :suspend<Enter>

            [messages]
            q = :prompt 'Quit?' quit<Enter>

            j = :next<Enter>
            <Down> = :next<Enter>
            <C-d> = :next 50%<Enter>
            <C-f> = :next 100%<Enter>
            <PgDn> = :next 100%<Enter>

            k = :prev<Enter>
            <Up> = :prev<Enter>
            <C-u> = :prev 50%<Enter>
            <C-b> = :prev 100%<Enter>
            <PgUp> = :prev 100%<Enter>
            g = :select 0<Enter>
            G = :select -1<Enter>

            J = :next-folder<Enter>
            <C-Down> = :next-folder<Enter>
            K = :prev-folder<Enter>
            <C-Up> = :prev-folder<Enter>
            H = :collapse-folder<Enter>
            <C-Left> = :collapse-folder<Enter>
            L = :expand-folder<Enter>
            <C-Right> = :expand-folder<Enter>

            v = :mark -t<Enter>
            <Space> = :mark -t<Enter>:next<Enter>
            V = :mark -v<Enter>

            T = :toggle-threads<Enter>
            zc = :fold<Enter>
            zo = :unfold<Enter>
            za = :fold -t<Enter>
            zM = :fold -a<Enter>
            zR = :unfold -a<Enter>
            <tab> = :exec checkmail<Enter>

            zz = :align center<Enter>
            zt = :align top<Enter>
            zb = :align bottom<Enter>

            <Enter> = :view<Enter>
            d = :choose -o y 'Really delete this message' delete-message<Enter>
            D = :delete<Enter>
            a = :read<Enter>:archive flat<Enter>
            A = :unmark -a<Enter>:mark -T<Enter>:read<Enter>:mark -T<EnteR>:archive flat<Enter>

            C = :compose<Enter>
            m = :compose<Enter>

            b = :bounce<space>

            rr = :reply -a<Enter>
            rq = :reply -aq<Enter>
            Rr = :reply<Enter>
            Rq = :reply -q<Enter>

            c = :cf<space>
            $ = :term<space>
            ! = :term<space>
            | = :pipe<space>

            / = :search<space>
            \ = :filter<space>
            n = :next-result<Enter>
            N = :prev-result<Enter>
            <Esc> = :clear<Enter>

            s = :split<Enter>
            S = :vsplit<Enter>

            pl = :patch list<Enter>
            pa = :patch apply <Tab>
            pd = :patch drop <Tab>
            pb = :patch rebase<Enter>
            pt = :patch term<Enter>
            ps = :patch switch <Tab>

            [messages:folder=Drafts]
            <Enter> = :recall<Enter>

            [view]
            / = :toggle-key-passthrough<Enter>/
            q = :close<Enter>
            O = :open<Enter>
            o = :open<Enter>
            S = :save<space>
            | = :pipe<space>
            D = :delete<Enter>
            A = :archive flat<Enter>

            <C-l> = :open-link <space>

            f = :forward<Enter>
            rr = :reply -a<Enter>
            rq = :reply -aq<Enter>
            Rr = :reply<Enter>
            Rq = :reply -q<Enter>

            H = :toggle-headers<Enter>
            <C-k> = :prev-part<Enter>
            <C-Up> = :prev-part<Enter>
            <C-j> = :next-part<Enter>
            <C-Down> = :next-part<Enter>
            J = :next<Enter>
            <C-Right> = :next<Enter>
            K = :prev<Enter>
            <C-Left> = :prev<Enter>

            [view::passthrough]
            $noinherit = true
            $ex = <C-x>
            <Esc> = :toggle-key-passthrough<Enter>

            [compose]
            # Keybindings used when the embedded terminal is not selected in the compose
            # view
            $noinherit = true
            $ex = <C-x>
            $complete = <C-o>
            <C-k> = :prev-field<Enter>
            <C-Up> = :prev-field<Enter>
            <C-j> = :next-field<Enter>
            <C-Down> = :next-field<Enter>
            <A-p> = :switch-account -p<Enter>
            <C-Left> = :switch-account -p<Enter>
            <A-n> = :switch-account -n<Enter>
            <C-Right> = :switch-account -n<Enter>
            <tab> = :next-field<Enter>
            <backtab> = :prev-field<Enter>
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>

            [compose::editor]
            # Keybindings used when the embedded terminal is selected in the compose view
            $noinherit = true
            $ex = <C-x>
            <C-k> = :prev-field<Enter>
            <C-Up> = :prev-field<Enter>
            <C-j> = :next-field<Enter>
            <C-Down> = :next-field<Enter>
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>

            [compose::review]
            # Keybindings used when reviewing a message to be sent
            # Inline comments are used as descriptions on the review screen
            y = :send<Enter> # Send
            n = :abort<Enter> # Abort (discard message, no confirmation)
            v = :preview<Enter> # Preview message
            p = :postpone<Enter> # Postpone
            q = :choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone
            e = :edit<Enter> # Edit
            a = :attach -m<space> # Add attachment
            d = :detach<space> # Remove attachment
            s = :sign<Enter> # PGP sign

            [terminal]
            $noinherit = true
            $ex = <C-x>

            <C-p> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-PgDn> = :next-tab<Enter>
          '';
        };

        notmuch = {
          enable = true;
          new = {
            ignore = [
              ".uidvalidity"
              ".mbsyncstate"
              ".mbsyncstate.lock"
              ".mbsyncstate.journal"
              ".mbsyncstate.new"
            ];
            tags = [ "unread" "inbox" "new" ];
          };
        };

        msmtp.enable = true;
        mbsync.enable = true;
      };

      services = {
        imapnotify.enable = true;
        mbsync.enable = true;
      };

      systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

      home.packages = with pkgs; [
        aerc
        w3m
        dante
      ];
    };
  };
}

