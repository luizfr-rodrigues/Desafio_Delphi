unit Model.ObserverInterface;

interface

Type

  IObserver = interface
    ['{A9CB364D-AAB7-4E26-BA5E-F4AF0DC28ABF}']
    procedure Atualizar();
  end;

  ISubject = interface
    ['{681652A1-8BE4-49C2-988A-8DB5AB3F3FFA}']
    procedure AdicionarObserver(Observer: IObserver);
    procedure Notificar;
  end;

implementation

end.
